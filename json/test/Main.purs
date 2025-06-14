module Test.JSON.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Data.Either (isLeft)
import Effect (Effect)
import Effect.Console (log)
import JSON as J
import JSON.Array as JA
import JSON.Object as JO
import JSON.Path as Path
import Test.Assert (assertTrue)

foreign import testJsonParser :: Effect Unit

main :: Effect Unit
main = do

  log "Check numeric comparisons"
  assertTrue $ J.fromInt 1 == J.fromInt 1
  assertTrue $ J.fromInt 1 < J.fromInt 2
  assertTrue $ J.fromInt 42 > J.fromInt 0

  log "Check string comparisons"
  assertTrue $ J.fromString "json" == J.fromString "json"
  assertTrue $ J.fromString "a" < J.fromString "b"
  assertTrue $ J.fromString "q" > J.fromString "p"

  log "Check array comparisons"
  assertTrue $ J.fromJArray (JA.fromArray []) == J.fromJArray (JA.fromArray [])
  assertTrue $ J.fromJArray (JA.fromArray [ J.fromInt 1 ]) == J.fromJArray (JA.fromArray [ J.fromInt 1 ])
  assertTrue $ J.fromJArray (JA.fromArray [ J.fromInt 1 ]) < J.fromJArray (JA.fromArray [ J.fromInt 2 ])

  log "Check object comparisons"
  assertTrue $ JO.empty == JO.empty
  assertTrue $ J.fromJObject (JO.fromEntries [ Tuple "a" (J.fromInt 1) ]) == J.fromJObject (JO.fromEntries [ Tuple "a" (J.fromInt 1) ])
  assertTrue $ J.fromJObject (JO.fromEntries [ Tuple "a" (J.fromInt 1) ]) < J.fromJObject (JO.fromEntries [ Tuple "a" (J.fromInt 2) ])

  log "Check isNull"
  assertTrue $ J.isNull J.null
  assertTrue $ not $ J.isNull (J.fromInt 1)

  log "Check array index"
  assertTrue $ JA.index (-1) (JA.fromArray (J.fromInt <$> [ 0, 2, 4 ])) == Nothing
  assertTrue $ JA.index 0 (JA.fromArray (J.fromInt <$> [ 0, 2, 4 ])) == Just (J.fromInt 0)
  assertTrue $ JA.index 1 (JA.fromArray (J.fromInt <$> [ 0, 2, 4 ])) == Just (J.fromInt 2)
  assertTrue $ JA.index 2 (JA.fromArray (J.fromInt <$> [ 0, 2, 4 ])) == Just (J.fromInt 4)
  assertTrue $ JA.index 3 (JA.fromArray (J.fromInt <$> [ 0, 2, 4 ])) == Nothing

  log "Check array concat"
  assertTrue $ JA.fromArray (J.fromInt <$> [ 1, 2 ]) <> JA.fromArray (J.fromInt <$> [ 2, 3 ]) == JA.fromArray (J.fromInt <$> [ 1, 2, 2, 3 ])

  log "Check path printing"
  assertTrue $ Path.print (Path.AtKey "data" (Path.AtIndex 0 (Path.AtKey "field" Path.Tip))) == "$.data[0].field"

  log "Check path get"
  assertTrue $ Path.get Path.Tip (J.fromString "hello") == Just (J.fromString "hello")
  assertTrue $ Path.get Path.Tip (J.fromJArray (JA.fromArray [ J.fromInt 42 ])) == Just (J.fromJArray (JA.fromArray [ J.fromInt 42 ]))
  assertTrue $ Path.get (Path.AtIndex 0 Path.Tip) (J.fromJArray (JA.fromArray [ J.fromInt 42, J.fromString "X", J.fromBoolean true ])) == Just (J.fromInt 42)
  assertTrue $ Path.get (Path.AtIndex 1 Path.Tip) (J.fromJArray (JA.fromArray [ J.fromInt 42, J.fromString "X", J.fromBoolean true ])) == Just (J.fromString "X")
  assertTrue $ Path.get (Path.AtIndex 5 Path.Tip) (J.fromJArray (JA.fromArray [ J.fromInt 42, J.fromString "X", J.fromBoolean true ])) == Nothing
  assertTrue $ Path.get (Path.AtKey "a" Path.Tip) (J.fromJObject (JO.fromEntries [ Tuple "a" (J.fromInt 1), Tuple "x" (J.fromBoolean false) ])) == Just (J.fromInt 1)
  assertTrue $ Path.get (Path.AtKey "x" Path.Tip) (J.fromJObject (JO.fromEntries [ Tuple "a" (J.fromInt 1), Tuple "x" (J.fromBoolean false) ])) == Just (J.fromBoolean false)
  assertTrue $ Path.get (Path.AtKey "z" Path.Tip) (J.fromJObject (JO.fromEntries [ Tuple "a" (J.fromInt 1), Tuple "x" (J.fromBoolean false) ])) == Nothing
  assertTrue $ Path.get (Path.AtIndex 1 (Path.AtKey "x" Path.Tip)) (J.fromJArray (JA.fromArray [ J.fromString "skip", (J.fromJObject (JO.fromEntries [ Tuple "a" (J.fromInt 1), Tuple "x" (J.fromBoolean false) ])) ])) == Just (J.fromBoolean false)

  log "Check path extend"
  assertTrue do
    let p1 = Path.AtKey "data" $ Path.AtIndex 0 $ Path.Tip
    let p2 = Path.AtKey "info" $ Path.AtKey "title" $ Path.Tip
    let expected = Path.AtKey "data" $ Path.AtIndex 0 $ Path.AtKey "info" $ Path.AtKey "title" $ Path.Tip
    Path.extend p1 p2 == expected

  log "Check path findCommonPrefix"
  assertTrue do
    let p1 = Path.AtKey "y" $ Path.AtKey "x" $ Path.AtIndex 1 $ Path.Tip
    let p2 = Path.AtKey "y" $ Path.AtKey "x" $ Path.AtIndex 0 $ Path.Tip
    let expected = Path.AtKey "y" $ Path.AtKey "x" $ Path.Tip
    Path.findCommonPrefix p1 p2 == expected
  assertTrue do
    let p1 = Path.AtKey "other" $ Path.Tip
    let p2 = Path.AtKey "y" $ Path.AtKey "x" $ Path.AtIndex 0 $ Path.Tip
    let expected = Path.Tip
    Path.findCommonPrefix p1 p2 == expected

  log "Check path stripPrefix"
  assertTrue do
    let p1 = Path.AtKey "y" Path.Tip
    let p2 = Path.AtKey "y" $ Path.AtKey "x" $ Path.AtIndex 0 $ Path.Tip
    let expected = Path.AtKey "x" $ Path.AtIndex 0 Path.Tip
    Path.stripPrefix p1 p2 == Just expected
  assertTrue do
    let p1 = Path.AtKey "y" $ Path.AtKey "x" $ Path.Tip
    let p2 = Path.AtKey "y" $ Path.AtKey "x" $ Path.AtIndex 0 Path.Tip
    let expected = Path.AtIndex 0 Path.Tip
    Path.stripPrefix p1 p2 == Just expected
  assertTrue do
    let p1 = Path.AtKey "other" Path.Tip
    let p2 = Path.AtKey "y" $ Path.AtKey "x" $ Path.AtIndex 0 Path.Tip
    Path.stripPrefix p1 p2 == Nothing

  log "Check JSON parsing"
  testJsonParser
  assertTrue $ J.parse "[]" == pure (J.fromJArray (JA.fromArray []))
  let obj =J.fromJObject (JO.fromEntries [ Tuple "foo" (J.fromNumber 123.45), Tuple "bar" (J.fromString "Hello PS!"), Tuple "baz" J.null ])
  assertTrue $ J.parse "{ \"foo\": 123.45, \"bar\": \"Hello PS!\", \"baz\": null }" == pure obj
  assertTrue $ isLeft (J.parse "{")
