{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses #-}
module Numeric.Ring.Opposite 
  ( Opposite(..)
  ) where

import Data.Foldable
import Data.Function (on)
import Data.Semigroup.Semifoldable
import Data.Semigroup.Semitraversable
import Data.Traversable
import Numeric.Algebra
import Numeric.Decidable.Associates
import Numeric.Decidable.Units
import Numeric.Decidable.Zero
import Prelude hiding ((-),(+),(*),(/),(^),recip,negate,subtract,replicate)

-- | http://en.wikipedia.org/wiki/Opposite_ring
newtype Opposite r = Opposite { runOpposite :: r } deriving (Show,Read)
instance Eq r => Eq (Opposite r) where
  (==) = (==) `on` runOpposite
instance Ord r => Ord (Opposite r) where
  compare = compare `on` runOpposite
instance Functor Opposite where
  fmap f (Opposite r) = Opposite (f r)
instance Foldable Opposite where
  foldMap f (Opposite r) = f r
instance Traversable Opposite where
  traverse f (Opposite r) = fmap Opposite (f r)
instance Semifoldable Opposite where
  semifoldMap f (Opposite r) = f r
instance Semitraversable Opposite where
  semitraverse f (Opposite r) = fmap Opposite (f r)
instance Additive r => Additive (Opposite r) where
  Opposite a + Opposite b = Opposite (a + b)
  sinnum1p n (Opposite a) = Opposite (sinnum1p n a)
  sumWith1 f = Opposite . sumWith1 (runOpposite . f)
instance Monoidal r => Monoidal (Opposite r) where
  zero = Opposite zero
  sinnum n (Opposite a) = Opposite (sinnum n a)
  sumWith f = Opposite . sumWith (runOpposite . f)
instance Semiring r => LeftModule (Opposite r) (Opposite r) where
  (.*) = (*)
instance RightModule r s => LeftModule r (Opposite s) where
  r .* Opposite s = Opposite (s *. r)
instance LeftModule r s => RightModule r (Opposite s) where
  Opposite s *. r = Opposite (r .* s)
instance Semiring r => RightModule (Opposite r) (Opposite r) where
  (*.) = (*)
instance Group r => Group (Opposite r) where
  negate = Opposite . negate . runOpposite
  Opposite a - Opposite b = Opposite (a - b)
  subtract (Opposite a) (Opposite b) = Opposite (subtract a b)
  times n (Opposite a) = Opposite (times n a)
instance Abelian r => Abelian (Opposite r)
instance DecidableZero r => DecidableZero (Opposite r) where
  isZero = isZero . runOpposite
instance DecidableUnits r => DecidableUnits (Opposite r) where
  recipUnit = fmap Opposite . recipUnit . runOpposite
instance DecidableAssociates r => DecidableAssociates (Opposite r) where
  isAssociate (Opposite a) (Opposite b) = isAssociate a b
instance Multiplicative r => Multiplicative (Opposite r) where
  Opposite a * Opposite b = Opposite (b * a)
  pow1p (Opposite a) n = Opposite (pow1p a n)
instance Commutative r => Commutative (Opposite r)
instance Idempotent r => Idempotent (Opposite r)
instance Band r => Band (Opposite r)
instance Unital r => Unital (Opposite r) where
  one = Opposite one
  pow (Opposite a) n = Opposite (pow a n)
instance Division r => Division (Opposite r) where
  recip = Opposite . recip . runOpposite
  Opposite a / Opposite b = Opposite (b \\ a)
  Opposite a \\ Opposite b = Opposite (b / a)
  Opposite a ^ n = Opposite (a ^ n)
instance Semiring r => Semiring (Opposite r)
instance Rig r => Rig (Opposite r)
instance Ring r => Ring (Opposite r)
