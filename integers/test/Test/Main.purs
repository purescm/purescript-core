module Test.Int.Main where

import Prelude

import Effect (Effect)

import Test.Data.Int (testInt)

main :: Effect Unit
main = testInt
