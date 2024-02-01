module Test.Lazy.Main where

import Prelude

import Data.Lazy (defer, force)
import Effect (Effect)
import Effect.Console (log)
import Test.Assert (assert)

main :: Effect Unit
main = do
  assert (force lazyString == laziness)
  log $ force lazyString
  where
    lazyString = defer \_ -> laziness
    laziness = "I'm so lazy!"
