module Tests.Data.StrMap where

import Data.Array (groupBy, map, sortBy)
import Data.Foldable (foldl)
import Data.Function (on)
import Data.Maybe (Maybe(..))
import Data.Int (fromNumber)
import Data.Tuple (Tuple(..), fst, zip)
import Debug.Trace
import Test.QuickCheck ((<?>), quickCheck, quickCheck')
import Test.QuickCheck.Arbitrary (Arbitrary, arbitrary)
import qualified Data.String as S
import qualified Data.StrMap as M

instance arbStrMap :: (Arbitrary v) => Arbitrary (M.StrMap v) where
  arbitrary = M.fromList <$> arbitrary

data Instruction k v = Insert k v | Delete k

instance showInstruction :: (Show k, Show v) => Show (Instruction k v) where
  show (Insert k v) = "Insert (" ++ show k ++ ") (" ++ show v ++ ")"
  show (Delete k) = "Delete (" ++ show k ++ ")"

instance arbInstruction :: (Arbitrary v) => Arbitrary (Instruction String v) where
  arbitrary = do
    b <- arbitrary
    k <- arbitrary
    case b of
      true -> do
        v <- arbitrary
        return (Insert k v)
      false -> do
        return (Delete k)

runInstructions :: forall v. [Instruction String v] -> M.StrMap v -> M.StrMap v
runInstructions instrs t0 = foldl step t0 instrs
  where
  step tree (Insert k v) = M.insert k v tree
  step tree (Delete k) = M.delete k tree

number :: Number -> Number
number n = n

strMapTests = do
  trace "Test inserting into empty tree"
  quickCheck $ \k v -> M.lookup k (M.insert k v M.empty) == Just (number v)
    <?> ("k: " ++ show k ++ ", v: " ++ show v)

  trace "Test delete after inserting"
  quickCheck $ \k v -> M.isEmpty (M.delete k (M.insert k (number v) M.empty))
    <?> ("k: " ++ show k ++ ", v: " ++ show v)

  trace "Insert two, lookup first"
  quickCheck $ \k1 v1 k2 v2 -> k1 == k2 || M.lookup k1 (M.insert k2 (number v2) (M.insert k1 (number v1) M.empty)) == Just v1
    <?> ("k1: " ++ show k1 ++ ", v1: " ++ show v1 ++ ", k2: " ++ show k2 ++ ", v2: " ++ show v2)

  trace "Insert two, lookup second"
  quickCheck $ \k1 v1 k2 v2 -> M.lookup k2 (M.insert k2 (number v2) (M.insert k1 (number v1) M.empty)) == Just v2
    <?> ("k1: " ++ show k1 ++ ", v1: " ++ show v1 ++ ", k2: " ++ show k2 ++ ", v2: " ++ show v2)

  trace "Insert two, delete one"
  quickCheck $ \k1 v1 k2 v2 -> k1 == k2 || M.lookup k2 (M.delete k1 (M.insert k2 (number v2) (M.insert k1 (number v1) M.empty))) == Just v2
    <?> ("k1: " ++ show k1 ++ ", v1: " ++ show v1 ++ ", k2: " ++ show k2 ++ ", v2: " ++ show v2)

  trace "Lookup from empty"
  quickCheck $ \k -> M.lookup k (M.empty :: M.StrMap Number) == Nothing

  trace "Lookup from singleton"
  quickCheck $ \k v -> M.lookup k (M.singleton k (v :: Number)) == Just v

  trace "Random lookup"
  quickCheck' (fromNumber 5000) $ \instrs k v ->
    let
      tree :: M.StrMap Number
      tree = M.insert k v (runInstructions instrs M.empty)
    in M.lookup k tree == Just v <?> ("instrs:\n  " ++ show instrs ++ "\nk:\n  " ++ show k ++ "\nv:\n  " ++ show v)

  trace "Singleton to list"
  quickCheck $ \k v -> M.toList (M.singleton k v :: M.StrMap Number) == [Tuple k v]

  trace "toList . fromList = id"
  quickCheck $ \arr -> let f x = M.toList (M.fromList x)
                       in f (f arr) == f (arr :: [Tuple String Number]) <?> show arr

  trace "fromList . toList = id"
  quickCheck $ \m -> let f m = M.fromList (M.toList m) in
                     M.toList (f m) == M.toList (m :: M.StrMap Number) <?> show m

  trace "fromListWith const = fromList"
  quickCheck $ \arr -> M.fromListWith const arr ==
                       M.fromList (arr :: [Tuple String Number]) <?> show arr

  trace "fromListWith (<>) = fromList . collapse with (<>) . group on fst"
  quickCheck $ \arr ->
    let combine (Tuple s a) (Tuple t b) = (Tuple s $ b <> a)
        foldl1 g (x : xs) = foldl g x xs
        f = M.fromList <<< (<$>) (foldl1 combine) <<<
            groupBy ((==) `on` fst) <<< sortBy (compare `on` fst) in
    M.fromListWith (<>) arr == f (arr :: [Tuple String String]) <?> show arr

  trace "Lookup from union"
  quickCheck $ \m1 m2 k -> M.lookup k (M.union m1 m2) == (case M.lookup k m1 of
    Nothing -> M.lookup k m2
    Just v -> Just (number v)) <?> ("m1: " ++ show m1 ++ ", m2: " ++ show m2 ++ ", k: " ++ show k ++ ", v1: " ++ show (M.lookup k m1) ++ ", v2: " ++ show (M.lookup k m2) ++ ", union: " ++ show (M.union m1 m2))

  trace "Union is idempotent"
  quickCheck $ \m1 m2 -> (m1 `M.union` m2) == ((m1 `M.union` m2) `M.union` (m2 :: M.StrMap Number)) <?> (show (M.size (m1 `M.union` m2)) ++ " != " ++ show (M.size ((m1 `M.union` m2) `M.union` m2)))

  trace "toList = zip keys values"
  quickCheck $ \m -> M.toList m == zip (M.keys m) (M.values m :: [Number])
