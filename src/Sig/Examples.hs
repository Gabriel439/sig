{-# LANGUAGE RecordWildCards #-}

module Sig.Examples where

import Sig (StateMachine(..), State(..), Transition(..))

-- Example transition matrix from paper for matching C-style comments
cStyleComments :: StateMachine
cStyleComments = StateMachine {..}
  where
    def = mempty
        { fromState00To = S00
        , fromState01To = S00
        , fromState02To = S02
        , fromState03To = S02
        }

    onByte000 = def
    onByte001 = def
    onByte002 = def
    onByte003 = def
    onByte004 = def
    onByte005 = def
    onByte006 = def
    onByte007 = def
    onByte008 = def
    onByte009 = def
    onByte010 = def
    onByte011 = def
    onByte012 = def
    onByte013 = def
    onByte014 = def
    onByte015 = def
    onByte016 = def
    onByte017 = def
    onByte018 = def
    onByte019 = def
    onByte020 = def
    onByte021 = def
    onByte022 = def
    onByte023 = def
    onByte024 = def
    onByte025 = def
    onByte026 = def
    onByte027 = def
    onByte028 = def
    onByte029 = def
    onByte030 = def
    onByte031 = def
    onByte032 = def
    onByte033 = def
    onByte034 = def
    onByte035 = def
    onByte036 = def
    onByte037 = def
    onByte038 = def
    onByte039 = def
    onByte040 = def
    onByte041 = def
    onByte042 = mempty
        { fromState00To = S00
        , fromState01To = S02
        , fromState02To = S03
        , fromState03To = S03
        }
    onByte043 = def
    onByte044 = def
    onByte045 = def
    onByte046 = def
    onByte047 = mempty
        { fromState00To = S01
        , fromState01To = S01
        , fromState02To = S02
        , fromState03To = S00
        }
    onByte048 = def
    onByte049 = def
    onByte050 = def
    onByte051 = def
    onByte052 = def
    onByte053 = def
    onByte054 = def
    onByte055 = def
    onByte056 = def
    onByte057 = def
    onByte058 = def
    onByte059 = def
    onByte060 = def
    onByte061 = def
    onByte062 = def
    onByte063 = def
    onByte064 = def
    onByte065 = def
    onByte066 = def
    onByte067 = def
    onByte068 = def
    onByte069 = def
    onByte070 = def
    onByte071 = def
    onByte072 = def
    onByte073 = def
    onByte074 = def
    onByte075 = def
    onByte076 = def
    onByte077 = def
    onByte078 = def
    onByte079 = def
    onByte080 = def
    onByte081 = def
    onByte082 = def
    onByte083 = def
    onByte084 = def
    onByte085 = def
    onByte086 = def
    onByte087 = def
    onByte088 = def
    onByte089 = def
    onByte090 = def
    onByte091 = def
    onByte092 = def
    onByte093 = def
    onByte094 = def
    onByte095 = def
    onByte096 = def
    onByte097 = def
    onByte098 = def
    onByte099 = def
    onByte100 = def
    onByte101 = def
    onByte102 = def
    onByte103 = def
    onByte104 = def
    onByte105 = def
    onByte106 = def
    onByte107 = def
    onByte108 = def
    onByte109 = def
    onByte110 = def
    onByte111 = def
    onByte112 = def
    onByte113 = def
    onByte114 = def
    onByte115 = def
    onByte116 = def
    onByte117 = def
    onByte118 = def
    onByte119 = def
    onByte120 = def
    onByte121 = def
    onByte122 = def
    onByte123 = def
    onByte124 = def
    onByte125 = def
    onByte126 = def
    onByte127 = def
    onByte128 = def
    onByte129 = def
    onByte130 = def
    onByte131 = def
    onByte132 = def
    onByte133 = def
    onByte134 = def
    onByte135 = def
    onByte136 = def
    onByte137 = def
    onByte138 = def
    onByte139 = def
    onByte140 = def
    onByte141 = def
    onByte142 = def
    onByte143 = def
    onByte144 = def
    onByte145 = def
    onByte146 = def
    onByte147 = def
    onByte148 = def
    onByte149 = def
    onByte150 = def
    onByte151 = def
    onByte152 = def
    onByte153 = def
    onByte154 = def
    onByte155 = def
    onByte156 = def
    onByte157 = def
    onByte158 = def
    onByte159 = def
    onByte160 = def
    onByte161 = def
    onByte162 = def
    onByte163 = def
    onByte164 = def
    onByte165 = def
    onByte166 = def
    onByte167 = def
    onByte168 = def
    onByte169 = def
    onByte170 = def
    onByte171 = def
    onByte172 = def
    onByte173 = def
    onByte174 = def
    onByte175 = def
    onByte176 = def
    onByte177 = def
    onByte178 = def
    onByte179 = def
    onByte180 = def
    onByte181 = def
    onByte182 = def
    onByte183 = def
    onByte184 = def
    onByte185 = def
    onByte186 = def
    onByte187 = def
    onByte188 = def
    onByte189 = def
    onByte190 = def
    onByte191 = def
    onByte192 = def
    onByte193 = def
    onByte194 = def
    onByte195 = def
    onByte196 = def
    onByte197 = def
    onByte198 = def
    onByte199 = def
    onByte200 = def
    onByte201 = def
    onByte202 = def
    onByte203 = def
    onByte204 = def
    onByte205 = def
    onByte206 = def
    onByte207 = def
    onByte208 = def
    onByte209 = def
    onByte210 = def
    onByte211 = def
    onByte212 = def
    onByte213 = def
    onByte214 = def
    onByte215 = def
    onByte216 = def
    onByte217 = def
    onByte218 = def
    onByte219 = def
    onByte220 = def
    onByte221 = def
    onByte222 = def
    onByte223 = def
    onByte224 = def
    onByte225 = def
    onByte226 = def
    onByte227 = def
    onByte228 = def
    onByte229 = def
    onByte230 = def
    onByte231 = def
    onByte232 = def
    onByte233 = def
    onByte234 = def
    onByte235 = def
    onByte236 = def
    onByte237 = def
    onByte238 = def
    onByte239 = def
    onByte240 = def
    onByte241 = def
    onByte242 = def
    onByte243 = def
    onByte244 = def
    onByte245 = def
    onByte246 = def
    onByte247 = def
    onByte248 = def
    onByte249 = def
    onByte250 = def
    onByte251 = def
    onByte252 = def
    onByte253 = def
    onByte254 = def
    onByte255 = def