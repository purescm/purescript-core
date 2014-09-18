module Tests.Data.Map where

import Debug.Trace

import Data.Maybe
import Data.Tuple
import Data.Array (map)
import Data.Function (on)
import Data.Foldable (foldl)

import Test.QuickCheck
import Test.QuickCheck.Tuple

import qualified Data.Map as M
import qualified Data.Set as S

instance arbMap :: (Eq k, Ord k, Arbitrary k, Arbitrary v) => Arbitrary (M.Map k v) where
  arbitrary = M.fromList <<< map runTestTuple <$> arbitrary

instance arbSet :: (Eq a, Ord a, Arbitrary a) => Arbitrary (S.Set a) where
  arbitrary = S.fromList <$> arbitrary

data SmallKey = A | B | C | D | E | F | G | H | I | J

instance showSmallKey :: Show SmallKey where
  show A = "A"
  show B = "B"
  show C = "C"
  show D = "D"
  show E = "E"
  show F = "F"
  show G = "G"
  show H = "H"
  show I = "I"
  show J = "J"

instance eqSmallKey :: Eq SmallKey where
  (==) A A = true
  (==) B B = true
  (==) C C = true
  (==) D D = true
  (==) E E = true
  (==) F F = true
  (==) G G = true
  (==) H H = true
  (==) I I = true
  (==) J J = true
  (==) _ _ = false
  (/=) x y = not (x == y)
  
smallKeyToNumber :: SmallKey -> Number
smallKeyToNumber A = 0
smallKeyToNumber B = 1
smallKeyToNumber C = 2
smallKeyToNumber D = 3
smallKeyToNumber E = 4
smallKeyToNumber F = 5
smallKeyToNumber G = 6
smallKeyToNumber H = 7
smallKeyToNumber I = 8
smallKeyToNumber J = 9 

instance ordSmallKey :: Ord SmallKey where
  compare = compare `on` smallKeyToNumber

instance arbSmallKey :: Arbitrary SmallKey where
  arbitrary = do
    n <- arbitrary
    return case n of
      _ | n < 0.1 -> A
      _ | n < 0.2 -> B
      _ | n < 0.3 -> C
      _ | n < 0.4 -> D
      _ | n < 0.5 -> E
      _ | n < 0.6 -> F
      _ | n < 0.7 -> G
      _ | n < 0.8 -> H
      _ | n < 0.9 -> I
      _ -> J

data Instruction k v = Insert k v | Delete k

instance showInstruction :: (Show k, Show v) => Show (Instruction k v) where
  show (Insert k v) = "Insert (" ++ show k ++ ") (" ++ show v ++ ")"
  show (Delete k) = "Delete (" ++ show k ++ ")"

instance arbInstruction :: (Arbitrary k, Arbitrary v) => Arbitrary (Instruction k v) where
  arbitrary = do
    b <- arbitrary
    case b of
      true -> do
        k <- arbitrary
        v <- arbitrary
        return (Insert k v)
      false -> do
        k <- arbitrary
        return (Delete k)
      
runInstructions :: forall k v. (Ord k) => [Instruction k v] -> M.Map k v -> M.Map k v
runInstructions instrs t0 = foldl step t0 instrs
  where
  step tree (Insert k v) = M.insert k v tree
  step tree (Delete k) = M.delete k tree

smallKey :: SmallKey -> SmallKey
smallKey k = k

number :: Number -> Number
number n = n

mapTests = do
  
  -- Data.Map
  
  trace "Test inserting into empty tree"
  quickCheck $ \k v -> M.lookup (smallKey k) (M.insert k v M.empty) == Just (number v)
    <?> ("k: " ++ show k ++ ", v: " ++ show v)

  trace "Test delete after inserting"
  quickCheck $ \k v -> M.isEmpty (M.delete (smallKey k) (M.insert k (number v) M.empty)) 
    <?> ("k: " ++ show k ++ ", v: " ++ show v)

  trace "Insert two, lookup first"
  quickCheck $ \k1 v1 k2 v2 -> k1 == k2 || M.lookup k1 (M.insert (smallKey k2) (number v2) (M.insert (smallKey k1) (number v1) M.empty)) == Just v1 
    <?> ("k1: " ++ show k1 ++ ", v1: " ++ show v1 ++ ", k2: " ++ show k2 ++ ", v2: " ++ show v2)

  trace "Insert two, lookup second"
  quickCheck $ \k1 v1 k2 v2 -> M.lookup k2 (M.insert (smallKey k2) (number v2) (M.insert (smallKey k1) (number v1) M.empty)) == Just v2  
    <?> ("k1: " ++ show k1 ++ ", v1: " ++ show v1 ++ ", k2: " ++ show k2 ++ ", v2: " ++ show v2)

  trace "Insert two, delete one"
  quickCheck $ \k1 v1 k2 v2 -> k1 == k2 || M.lookup k2 (M.delete k1 (M.insert (smallKey k2) (number v2) (M.insert (smallKey k1) (number v1) M.empty))) == Just v2 
    <?> ("k1: " ++ show k1 ++ ", v1: " ++ show v1 ++ ", k2: " ++ show k2 ++ ", v2: " ++ show v2)
  
  trace "Check balance property"
  quickCheck' 5000 $ \instrs -> 
    let
      tree :: M.Map SmallKey Number
      tree = runInstructions instrs M.empty
    in M.checkValid tree <?> ("Map not balanced:\n  " ++ show tree ++ "\nGenerated by:\n  " ++ show instrs)
    
  trace "Lookup from empty"
  quickCheck $ \k -> M.lookup k (M.empty :: M.Map SmallKey Number) == Nothing

  trace "Lookup from singleton"
  quickCheck $ \k v -> M.lookup (k :: SmallKey) (M.singleton k (v :: Number)) == Just v

  trace "Random lookup"
  quickCheck' 5000 $ \instrs k v ->
    let
      tree :: M.Map SmallKey Number
      tree = M.insert k v (runInstructions instrs M.empty)
    in M.lookup k tree == Just v <?> ("instrs:\n  " ++ show instrs ++ "\nk:\n  " ++ show k ++ "\nv:\n  " ++ show v)

  trace "Singleton to list"
  quickCheck $ \k v -> M.toList (M.singleton k v :: M.Map SmallKey Number) == [Tuple k v]

  trace "toList . fromList = id"
  quickCheck $ \arr -> let f x = M.toList (M.fromList x) 
                           arr' = runTestTuple <$> arr
                       in f (f arr') == f (arr' :: [Tuple SmallKey Number]) <?> show arr

  trace "fromList . toList = id"
  quickCheck $ \m -> let f m = M.fromList (M.toList m) in
                     M.toList (f m) == M.toList (m :: M.Map SmallKey Number) <?> show m
  
  trace "Lookup from union"
  quickCheck $ \m1 m2 k -> M.lookup (smallKey k) (M.union m1 m2) == (case M.lookup k m1 of 
    Nothing -> M.lookup k m2
    Just v -> Just (number v)) <?> ("m1: " ++ show m1 ++ ", m2: " ++ show m2 ++ ", k: " ++ show k ++ ", v1: " ++ show (M.lookup k m1) ++ ", v2: " ++ show (M.lookup k m2) ++ ", union: " ++ show (M.union m1 m2))
 
  trace "Union is idempotent"
  quickCheck $ \m1 m2 -> (m1 `M.union` m2) == ((m1 `M.union` m2) `M.union` (m2 :: M.Map SmallKey Number))
  
  -- Data.Set

  trace "testMemberEmpty: member _ empty == false"
  quickCheck $ \a -> S.member a (S.empty :: S.Set SmallKey) == false

  trace "testMemberSingleton: member a (singleton a) == true"
  quickCheck $ \a -> S.member (a :: SmallKey) (S.singleton a) == true

  trace "testInsertDelete: member a (delete a (insert a empty) == false)"
  quickCheck $ \a -> (S.member (a :: SmallKey) $ 
                          S.delete a $ 
                          S.insert a S.empty) == false

  trace "testSingletonToList: toList (singleton a) == [a]"
  quickCheck $ \a -> S.toList (S.singleton a :: S.Set SmallKey) == [a]

  trace "testToListFromList: toList . fromList = id"
  quickCheck $ \arr -> let f x = S.toList (S.fromList x) in
                           f (f arr) == f (arr :: [SmallKey])

  trace "testFromListToList: fromList . toList = id"
  quickCheck $ \s -> let f s = S.fromList (S.toList s) in
                     S.toList (f s) == S.toList (s :: S.Set SmallKey)

  trace "testUnionSymmetric: union s1 s2 == union s2 s1"
  quickCheck $ \s1 s2 -> let s3 = s1 `S.union` (s2 :: S.Set SmallKey) in
                         let s4 = s2 `S.union` s1 in
                         S.toList s3 == S.toList s4

  trace "testUnionIdempotent"
  quickCheck $ \s1 s2 -> (s1 `S.union` s2) == ((s1 `S.union` s2) `S.union` (s2 :: S.Set SmallKey))
