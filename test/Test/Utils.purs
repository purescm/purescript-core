module Test.Utils where

import Prelude

import Effect (Effect)

assert :: String -> Boolean -> Effect Unit
assert msg condition = if condition then pure unit else throwErr msg

foreign import throwErr :: String -> Effect Unit
