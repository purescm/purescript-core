module Example.ParseErrors where

import Prelude

import Data.Foreign
import Data.Foreign.Class

-- | See the `Objects` example for an explanation of how to parse objects
--   like this.
data Point = Point { x :: Number, y :: Number }

instance showPoint :: Show Point where
  show (Point o) = "Point { x: " ++ show o.x ++ ", y: " ++ show o.y ++ " }"

instance pointIsForeign :: IsForeign Point where
  read value = do
    x <- readProp "x" value
    y <- readProp "y" value
    return $ Point { x: x, y: y }

main = do

  -- When trying to parse invalid JSON we catch an exception from
  -- `JSON.parse` and pass it on.
  Console.print $ readJSON "not even JSON" :: F String

  -- When attempting to coerce one type to another we get an error.
  Console.print $ readJSON "26" :: F Boolean

  -- When parsing fails in an array, we're told at which index the value that
  -- failed to parse was, along with the reason the value didn't parse.
  Console.print $ readJSON "[1, true, 3]" :: F (Array Boolean)

  -- When parsing fails in an object, we're the name of the property which
  -- failed to parse was, along with the reason the value didn't parse.
  Console.print $ readJSON """{ "x": 1, "y": false }""" :: F Point
