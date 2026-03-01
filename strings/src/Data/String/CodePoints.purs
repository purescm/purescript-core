-- | These functions allow PureScript strings to be treated as if they were
-- | sequences of Unicode code points instead of their true underlying
-- | implementation (sequences of UTF-16 code units). For nearly all uses of
-- | strings, these functions should be preferred over the ones in
-- | `Data.String.CodeUnits`.
module Data.String.CodePoints
  ( module Exports
  , CodePoint
  , codePointFromChar
  , singleton
  , fromCodePointArray
  , toCodePointArray
  , codePointAt
  , uncons
  , length
  , countPrefix
  , indexOf
  , indexOf'
  , lastIndexOf
  , lastIndexOf'
  , take
  -- , takeRight
  , takeWhile
  , drop
  -- , dropRight
  , dropWhile
  -- , slice
  , splitAt
  ) where

import Prelude

import Data.Enum (class BoundedEnum, class Enum, Cardinality(..), defaultPred, defaultSucc, fromEnum, toEnum)

import Data.Int (hexadecimal, toStringAs)
import Data.Maybe (Maybe(..))
import Data.String.CodeUnits (contains, stripPrefix, stripSuffix) as Exports
import Data.String.CodeUnits as CU
import Data.String.Common (toUpper)
import Data.String.Pattern (Pattern)

-- | CodePoint is an `Int` bounded between `0` and `0x10FFFF`, corresponding to
-- | Unicode code points.
newtype CodePoint = CodePoint Int

derive instance eqCodePoint :: Eq CodePoint
derive instance ordCodePoint :: Ord CodePoint

instance showCodePoint :: Show CodePoint where
  show (CodePoint i) = "(CodePoint 0x" <> toUpper (toStringAs hexadecimal i) <> ")"

instance boundedCodePoint :: Bounded CodePoint where
  bottom = CodePoint 0
  top = CodePoint 0x10FFFF

instance enumCodePoint :: Enum CodePoint where
  succ = defaultSucc toEnum fromEnum
  pred = defaultPred toEnum fromEnum

instance boundedEnumCodePoint :: BoundedEnum CodePoint where
  cardinality = Cardinality (0x10FFFF + 1)
  fromEnum (CodePoint n) = n
  toEnum n
    | n >= 0 && n <= 0x10FFFF = Just (CodePoint n)
    | otherwise = Nothing

-- | Creates a `CodePoint` from a given `Char`.
-- |
-- | ```purescript
-- | >>> codePointFromChar 'B'
-- | CodePoint 0x42 -- represents 'B'
-- | ```
-- |
codePointFromChar :: Char -> CodePoint
codePointFromChar = fromEnum >>> CodePoint

-- | Creates a string containing just the given code point. Operates in
-- | constant space and time.
-- |
-- | ```purescript
-- | >>> map singleton (toEnum 0x1D400)
-- | Just "𝐀"
-- | ```
-- |
foreign import singleton :: CodePoint -> String

-- | Creates a string from an array of code points. Operates in space and time
-- | linear to the length of the array.
-- |
-- | ```purescript
-- | >>> codePointArray = toCodePointArray "c 𝐀"
-- | >>> codePointArray
-- | [CodePoint 0x63, CodePoint 0x20, CodePoint 0x1D400]
-- | >>> fromCodePointArray codePointArray
-- | "c 𝐀"
-- | ```
-- |
foreign import fromCodePointArray :: Array CodePoint -> String

-- | Creates an array of code points from a string. Operates in space and time
-- | linear to the length of the string.
-- |
-- | ```purescript
-- | >>> codePointArray = toCodePointArray "b 𝐀𝐀"
-- | >>> codePointArray
-- | [CodePoint 0x62, CodePoint 0x20, CodePoint 0x1D400, CodePoint 0x1D400]
-- | >>> map singleton codePointArray
-- | ["b", " ", "𝐀", "𝐀"]
-- | ```
-- |
foreign import toCodePointArray :: String -> Array CodePoint

-- | Returns the first code point of the string after dropping the given number
-- | of code points from the beginning, if there is such a code point. Operates
-- | in constant space and in time linear to the given index.
-- |
-- | ```purescript
-- | >>> codePointAt 1 "𝐀𝐀𝐀𝐀"
-- | Just (CodePoint 0x1D400) -- represents "𝐀"
-- | -- compare to Data.String:
-- | >>> charAt 1 "𝐀𝐀𝐀𝐀"
-- | Just '�'
-- | ```
-- |
codePointAt :: Int -> String -> Maybe CodePoint
codePointAt n _ | n < 0 = Nothing
codePointAt 0 "" = Nothing
codePointAt 0 s = Just (unsafeCodePointAt0 s)
codePointAt n s = _codePointAt Just Nothing n s

foreign import _codePointAt
  :: (forall a. a -> Maybe a)
  -> (forall a. Maybe a)
  -> Int
  -> String
  -> Maybe CodePoint

-- | Returns a record with the first code point and the remaining code points
-- | of the string. Returns `Nothing` if the string is empty. Operates in
-- | constant space and time.
-- |
-- | ```purescript
-- | >>> uncons "𝐀𝐀 c 𝐀"
-- | Just { head: CodePoint 0x1D400, tail: "𝐀 c 𝐀" }
-- | >>> uncons ""
-- | Nothing
-- | ```
-- |
-- Note: this uses a foreign implementation to work correctly on backends where
-- strings are not UTF-16 (e.g. Chez Scheme). The upstream version uses
-- PureScript-level surrogate pair handling which relies on UTF-16 code units.
uncons :: String -> Maybe { head :: CodePoint, tail :: String }
uncons = _uncons Just Nothing

foreign import _uncons
  :: (forall a. a -> Maybe a)
  -> (forall a. Maybe a)
  -> String
  -> Maybe { head :: CodePoint, tail :: String }

-- | Returns the number of code points in the string. Operates in constant
-- | space and in time linear to the length of the string.
-- |
-- | ```purescript
-- | >>> length "b 𝐀𝐀 c 𝐀"
-- | 8
-- | -- compare to Data.String:
-- | >>> length "b 𝐀𝐀 c 𝐀"
-- | 11
-- | ```
-- |
foreign import length :: String -> Int

-- | Returns the number of code points in the leading sequence of code points
-- | which all match the given predicate. Operates in constant space and in
-- | time linear to the length of the string.
-- |
-- | ```purescript
-- | >>> countPrefix (\c -> fromEnum c == 0x1D400) "𝐀𝐀 b c 𝐀"
-- | 2
-- | ```
-- |
foreign import countPrefix :: (CodePoint -> Boolean) -> String -> Int

-- | Returns the number of code points preceding the first match of the given
-- | pattern in the string. Returns `Nothing` when no matches are found.
-- |
-- | ```purescript
-- | >>> indexOf (Pattern "𝐀") "b 𝐀𝐀 c 𝐀"
-- | Just 2
-- | >>> indexOf (Pattern "o") "b 𝐀𝐀 c 𝐀"
-- | Nothing
-- | ```
-- |
indexOf :: Pattern -> String -> Maybe Int
indexOf p s = (\i -> length (CU.take i s)) <$> CU.indexOf p s

-- | Returns the number of code points preceding the first match of the given
-- | pattern in the string. Pattern matches preceding the given index will be
-- | ignored. Returns `Nothing` when no matches are found.
-- |
-- | ```purescript
-- | >>> indexOf' (Pattern "𝐀") 4 "b 𝐀𝐀 c 𝐀"
-- | Just 7
-- | >>> indexOf' (Pattern "o") 4 "b 𝐀𝐀 c 𝐀"
-- | Nothing
-- | ```
-- |
indexOf' :: Pattern -> Int -> String -> Maybe Int
indexOf' p i s =
  let s' = drop i s in
  (\k -> i + length (CU.take k s')) <$> CU.indexOf p s'

-- | Returns the number of code points preceding the last match of the given
-- | pattern in the string. Returns `Nothing` when no matches are found.
-- |
-- | ```purescript
-- | >>> lastIndexOf (Pattern "𝐀") "b 𝐀𝐀 c 𝐀"
-- | Just 7
-- | >>> lastIndexOf (Pattern "o") "b 𝐀𝐀 c 𝐀"
-- | Nothing
-- | ```
-- |
lastIndexOf :: Pattern -> String -> Maybe Int
lastIndexOf p s = (\i -> length (CU.take i s)) <$> CU.lastIndexOf p s

-- | Returns the number of code points preceding the first match of the given
-- | pattern in the string. Pattern matches following the given index will be
-- | ignored.
-- |
-- | Giving a negative index is equivalent to giving 0 and giving an index
-- | greater than the number of code points in the string is equivalent to
-- | searching in the whole string.
-- |
-- | Returns `Nothing` when no matches are found.
-- |
-- | ```purescript
-- | >>> lastIndexOf' (Pattern "𝐀") (-1) "b 𝐀𝐀 c 𝐀"
-- | Nothing
-- | >>> lastIndexOf' (Pattern "𝐀") 0 "b 𝐀𝐀 c 𝐀"
-- | Nothing
-- | >>> lastIndexOf' (Pattern "𝐀") 5 "b 𝐀𝐀 c 𝐀"
-- | Just 3
-- | >>> lastIndexOf' (Pattern "𝐀") 8 "b 𝐀𝐀 c 𝐀"
-- | Just 7
-- | >>> lastIndexOf' (Pattern "o") 5 "b 𝐀𝐀 c 𝐀"
-- | Nothing
-- | ```
-- |
lastIndexOf' :: Pattern -> Int -> String -> Maybe Int
lastIndexOf' p i s =
  let i' = CU.length (take i s) in
  (\k -> length (CU.take k s)) <$> CU.lastIndexOf' p i' s

-- | Returns a string containing the given number of code points from the
-- | beginning of the given string. If the string does not have that many code
-- | points, returns the empty string. Operates in constant space and in time
-- | linear to the given number.
-- |
-- | ```purescript
-- | >>> take 3 "b 𝐀𝐀 c 𝐀"
-- | "b 𝐀"
-- | -- compare to Data.String:
-- | >>> take 3 "b 𝐀𝐀 c 𝐀"
-- | "b �"
-- | ```
-- |
foreign import take :: Int -> String -> String

-- | Returns a string containing the leading sequence of code points which all
-- | match the given predicate from the string. Operates in constant space and
-- | in time linear to the length of the string.
-- |
-- | ```purescript
-- | >>> takeWhile (\c -> fromEnum c == 0x1D400) "𝐀𝐀 b c 𝐀"
-- | "𝐀𝐀"
-- | ```
-- |
takeWhile :: (CodePoint -> Boolean) -> String -> String
takeWhile p s = take (countPrefix p s) s

-- | Drops the given number of code points from the beginning of the string. If
-- | the string does not have that many code points, returns the empty string.
-- | Operates in constant space and in time linear to the given number.
-- |
-- | ```purescript
-- | >>> drop 5 "𝐀𝐀 b c"
-- | "c"
-- | -- compared to Data.String:
-- | >>> drop 5 "𝐀𝐀 b c"
-- | "b c" -- because "𝐀" occupies 2 code units
-- | ```
-- |
drop :: Int -> String -> String
drop n s = CU.drop (CU.length (take n s)) s

-- | Drops the leading sequence of code points which all match the given
-- | predicate from the string. Operates in constant space and in time linear
-- | to the length of the string.
-- |
-- | ```purescript
-- | >>> dropWhile (\c -> fromEnum c == 0x1D400) "𝐀𝐀 b c 𝐀"
-- | " b c 𝐀"
-- | ```
-- |
dropWhile :: (CodePoint -> Boolean) -> String -> String
dropWhile p s = drop (countPrefix p s) s

-- | Splits a string into two substrings, where `before` contains the code
-- | points up to (but not including) the given index, and `after` contains the
-- | rest of the string, from that index on.
-- |
-- | ```purescript
-- | >>> splitAt 3 "b 𝐀𝐀 c 𝐀"
-- | { before: "b 𝐀", after: "𝐀 c 𝐀" }
-- | ```
-- |
-- | Thus the length of `(splitAt i s).before` will equal either `i` or
-- | `length s`, if that is shorter. (Or if `i` is negative the length will be
-- | 0.)
-- |
-- | In code:
-- | ```purescript
-- | length (splitAt i s).before == min (max i 0) (length s)
-- | (splitAt i s).before <> (splitAt i s).after == s
-- | splitAt i s == {before: take i s, after: drop i s}
-- | ```
splitAt :: Int -> String -> { before :: String, after :: String }
splitAt i s =
  let before = take i s in
  { before
  -- inline drop i s to reuse the result of take i s
  , after: CU.drop (CU.length before) s
  }

-- WARN: this function expects the String parameter to be non-empty
foreign import unsafeCodePointAt0 :: String -> CodePoint
