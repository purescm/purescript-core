module Main where

import Prelude
import Control.Monad.Eff
import QuickCheck

testConst :: Number -> Number -> Number -> Boolean
testConst a b c = const a b == const a c

testReadShow :: Number -> Boolean
testReadShow a = a == read (show a)

main = do
  Debug.Trace.trace "testConst:"
  quickCheck testConst

  Debug.Trace.trace "testReadShow:"
  quickCheck testReadShow

  Debug.Trace.trace "Precedence of && and ||:"
  quickCheck $ \a b c -> ((a :: Boolean && b) || c) == ((a || c) && (b || c))
  
  Debug.Trace.trace "Test Eq instance for Ref:"
  quickCheck $ \a -> (Ref a :: Ref Number) == Ref a
  quickCheck $ \a -> not $ (Ref a :: Ref Number /= Ref a)
