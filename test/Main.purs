module Test.Main where

import Prelude

import Control.Monad.ST as ST
import Control.Monad.ST.Ref as STRef
import Effect (Effect)
import Effect.Class.Console as Console
import Test.Assert (assert')

sumOfSquares :: Int
sumOfSquares = ST.run do
  total <- STRef.new 0
  let loop 0 = STRef.read total
      loop n = do
        _ <- STRef.modify (_ + (n * n)) total
        loop (n - 1)
  loop 100

testForLoop :: Int -> Int -> Int
testForLoop lo hi = ST.run do
  total <- STRef.new 0
  ST.for lo hi \n -> do
    STRef.modify (_ + (n * n)) total
  STRef.read total

testWhile :: Int
testWhile = ST.run do
  total <- STRef.new 0
  let
    computation = STRef.modify (_ + 1) total
    condition = (_ < 100) <$> STRef.read total
  ST.while condition computation
  STRef.read total

testForeach :: Int
testForeach = ST.run do
  total <- STRef.new 0
  ST.foreach [1,2,3] \n -> do
    _ <- STRef.modify (_ + n) total
    pure unit
  STRef.read total

main :: Effect Unit
main = do
  assert' "Sum of squares" $ sumOfSquares == 338350
  assert' "for-loop" $ [testForLoop 0 0, testForLoop 1 4, testForLoop 0 101] == [0, 14, 338350]
  assert' "while-loop" $ testWhile == 100
  assert' "foreach" $ testForeach == 6
  Console.log "All good!"
