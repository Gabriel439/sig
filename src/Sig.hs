{-| This library provides a very efficient implementation of parallel state
    machines running over `ByteString` inputs based on the following paper:

    > Mytkowicz, Todd, Madanlal Musuvathi, and Wolfram Schulte. "Data-parallel
    > finite-state machines." ACM SIGARCH Computer Architecture News. Vol. 42.
    > No. 1. ACM, 2014.

    These state machines are \"parallel\" in two senses of the word:

    * The machine simulates multiple states in parallel
    * You can process the input `ByteString` itself in parallel

    This state machine implementation gives excellent performance which also
    scales linearly with the number of available cores

    The main limitation of this library is that the state machines are currently
    limited to 16 states
-}

module Sig
    ( -- * Example
      -- $example

      -- * Building state machines
      buildStateMachine
    , State(..)
    , Transition(..)
    , StateMachine(..)

      -- * Running state machines
    , run

    ) where

import Data.ByteString (ByteString)
import Foreign (Ptr)
import Foreign.C.Types (CChar(..), CSize(..))
import Sig.State
import Sig.StateMachine
import Sig.Transition

import qualified Control.Parallel.Strategies
import qualified Data.Binary
import qualified Data.ByteString
import qualified Data.ByteString.Lazy
import qualified Data.ByteString.Unsafe
import qualified Foreign
import qualified Foreign.Marshal.Unsafe

-- $example
-- 
-- Here is an example of how you would define a `StateMachine` that parses
-- C-style block comments using four states (which you can find in the
-- "Sig.Examples" module):
--
-- * `S00` - Starting state and final state for a well-formed comment
-- * `S01` - Just parsed a @\'/\'@ that might be the first character in @\"/*\"@
-- * `S02` - In the middle of a block comment
-- * `S03` - Just parsed a @\'*\'@ that might be the first character in @\"*/\"@
--
-- > {-# LANGUAGE RecordWildCards #-}
-- > 
-- > import Sig (State(..), StateMachine)
-- > 
-- > import qualified Sig
-- > 
-- > cStyleComments :: StateMachine
-- > cStyleComments = Sig.buildStateMachine f
-- >   where
-- >     -- 47 is the ASCII encoding for '/'
-- >     f 47 S00 = S01  -- Possible comment start: Go to state #1
-- >     f 47 S01 = S01
-- >     f 47 S02 = S02
-- >     f 47 S03 = S00  -- Confirmed comment end: Go to state #0
-- >
-- >     -- 42 is the ASCII encoding for '*'
-- >     f 42 S00 = S00
-- >     f 42 S01 = S02  -- Confirmed comment start: Go to state #2
-- >     f 42 S02 = S03  -- Possible comment end: Go to state #3
-- >     f 42 S03 = S03
-- >
-- >     -- This covers all other ASCII characters
-- >     f  _ S00 = S00  -- Still outside a comment: Stay on state #0
-- >     f  _ S01 = S00
-- >     f  _ S02 = S02  -- Still inside a comment: Stay on state #2
-- >     f  _ S03 = S02
-- > 
-- >     -- This covers all other states (which we don't use)
-- >     f  _ _   = S00
--
-- ... and here is an example of using the above `StateMachine` on a file:
--
-- > module Sig.Main where
-- >
-- > import Sig (State(..), Transition(..))
-- >
-- > import qualified Control.Concurrent
-- > import qualified Sig
-- > import qualified Sig.Examples
-- > import qualified System.IO.MMap
-- >
-- > main :: IO ()
-- > main = do
-- >     n     <- Control.Concurrent.getNumCapabilities
-- >     bytes <- System.IO.MMap.mmapFileByteString "example.c" Nothing
-- >     let transition = Sig.run n Sig.Examples.cStyleComments bytes
-- >     print (runTransition transition S00 == S00)

foreign import ccall "run" c_run
    :: Ptr CChar -> CSize -> Ptr CChar -> Ptr CChar -> IO ()

{-| Wrap the @c_run@ function in a Haskell API

    prop> runSerial (StateMachine f) bytes == foldMap f (Data.ByteString.unpack bytes)
-}
runSerial :: StateMachine -> ByteString -> Transition
runSerial matrix bytes = Data.Binary.decode (Data.ByteString.Lazy.fromStrict (
    Foreign.Marshal.Unsafe.unsafeLocalState (do
        Data.ByteString.Unsafe.unsafeUseAsCStringLen tBytes (\(ptrTBytes, _) ->
            Data.ByteString.Unsafe.unsafeUseAsCStringLen bytes (\(ptrIn, len) ->
                Foreign.allocaBytes 16 (\ptrOut -> do
                    c_run ptrIn (fromIntegral len) ptrTBytes ptrOut
                    Data.ByteString.packCStringLen (ptrOut, 16) ) ) ) ) ))
  where
    tBytes = Data.ByteString.Lazy.toStrict (Data.Binary.encode matrix)

-- | Split a `ByteString` into chunks of size @n@
chunkBytes :: Int -> ByteString -> [ByteString]
chunkBytes n bytes =
    if Data.ByteString.null bytes
    then []
    else prefix : chunkBytes n suffix
  where
    ~(prefix, suffix) = Data.ByteString.splitAt n bytes

{-| Run a `StateMachine` on a `ByteString`

    `run` returns a `Transition` that computes what the final state would be for
    each possible initial state

    The implementation is equivalent to:

    prop> run n (StateMachine f) bytes == foldMap f (Data.ByteString.unpack bytes)

    ... except much more efficient and parallel

    The first argument specifies how many threads to use to accelerate the
    computation.  A good rule of thumb is to use the number of cores your
    machine has, like this:

    > ...
    > numCores <- Control.Concurrent.getNumCapabilities
    > let transition = run numCores stateMachine bytes
    > ...

    ... or you can just specify @1@ thread for a serial implementation (which
    will still be really efficient)

    `run` is \"embarassingly parallel\", meaning that the performance scales
    linearly with the number of available cores
-}
run :: Int
    -- ^ Number of threads to use
    -> StateMachine
    -- ^ State machine to run over the input bytes
    -> ByteString
    -- ^ Input bytes to feed to the state machine
    -> Transition
    -- ^ Computed function from every starting state to every final state
run 1          matrix bytes = runSerial matrix bytes
run numThreads matrix bytes =
    mconcat
        (Control.Parallel.Strategies.parMap
            Control.Parallel.Strategies.rseq
            (runSerial matrix)
            (chunkBytes subLen bytes) )
  where
    len = Data.ByteString.length bytes

    subLen = ((len - 1) `div` numThreads) + 1
