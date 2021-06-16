{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveFoldable #-}
{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE DeriveTraversable #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TupleSections #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE ViewPatterns #-}

-- |
-- Module       : Data.Map.Monoidal.Strict
-- Copyright    : (c) Melanie Brown 2021
-- License      : BSD3 (see the file LICENSE)
-- Maintainer   : brown.m@pm.me
--
-- This module defines a deeply-nested, semigroup-lifting map datatype,
-- whose keys are indexed by a type-level list.
--
-- Its interface is intended to mimic that of 'Data.Map.Strict' from the
-- @containers@ package, with additional convenience functions for working with deep nestings.
module Data.Map.Monoidal.Deep (
    -- * Map type
    DeepMap (..),
    getBare,
    getNest,
    onBare2,
    onNest2,

    -- * Construction
    empty,
    singleton,
    (@>),
    (@|),

    -- ** From Unordered Lists
    fromList,
    fromList1,
    fromList2,
    fromList3,
    fromList4,
    fromList5,
    fromListWith,
    fromListWith1,
    fromListWithKey,
    fromListWithKey1,
    fromListWithKey2,
    fromListWithKey3,
    fromListWithKey4,
    fromListWithKey5,

    -- ** Single-depth map isomorphisms
    toMap,
    fromMap,
    toMonoidalMap,
    fromMonoidalMap,

    -- * Insertion
    insert,
    insert1,
    insert2,
    insert3,
    insert4,
    insert5,
    insertWith,
    insertWith1,
    insertWith2,
    insertWith3,
    insertWith4,
    insertWith5,
    insertWithKey,
    insertWithKey1,
    insertWithKey2,
    insertWithKey3,
    insertWithKey4,
    insertWithKey5,
    insertLookupWithKey,
    insertLookupWithKey1,
    insertLookupWithKey2,
    insertLookupWithKey3,
    insertLookupWithKey4,
    insertLookupWithKey5,
    overwrite,
    overwrite1,
    overwrite2,
    overwrite3,
    overwrite4,
    overwrite5,
    overwriteLookup,
    overwriteLookup1,
    overwriteLookup2,
    overwriteLookup3,
    overwriteLookup4,
    overwriteLookup5,

    -- * Deletion\/Update
    delete,
    delete1,
    delete2,
    delete3,
    delete4,
    delete5,
    adjust,
    adjust1,
    adjust2,
    adjust3,
    adjust4,
    adjust5,
    adjustWithKey,
    adjustWithKey1,
    adjustWithKey2,
    adjustWithKey3,
    adjustWithKey4,
    adjustWithKey5,
    update,
    update1,
    update2,
    update3,
    update4,
    update5,
    updateWithKey,
    updateWithKey1,
    updateWithKey2,
    updateWithKey3,
    updateWithKey4,
    updateWithKey5,
    updateLookupWithKey,
    updateLookupWithKey1,
    updateLookupWithKey2,
    updateLookupWithKey3,
    updateLookupWithKey4,
    updateLookupWithKey5,
    alter,
    alter1,
    alter2,
    alter3,
    alter4,
    alter5,
    alterF,
    alterF1,
    alterF2,
    alterF3,
    alterF4,
    alterF5,

    -- * Query

    -- ** Lookup
    lookup,
    (@?),
    (@?|),
    (@??),
    (@??|),
    (@!),
    (@!|),
    findWithDefault,
    findWithDefault1,
    findWithDefault2,
    findWithDefault3,
    findWithDefault4,
    findWithDefault5,
    member,
    notMember,
    lookupLT,
    lookupGT,
    lookupLE,
    lookupGE,

    -- ** Size
    null,
    size,

    -- * Combine

    -- ** Union
    union,
    unionWith,
    unionWith1,
    unionWith2,
    unionWith3,
    unionWith4,
    unionWith5,
    unionWithKey,
    unionWithKey1,
    unionWithKey2,
    unionWithKey3,
    unionWithKey4,
    unionWithKey5,
    unions,
    unionsWith,
    unionsWith1,

    -- ** Difference
    difference,
    (\\),
    differenceWith,
    differenceWith1,
    differenceWithKey,
    differenceWithKey1,

    -- ** Intersection
    intersection,
    intersectionWith,
    intersectionWith1,
    intersectionWithKey,
    intersectionWithKey1,
    intersectionWithKey2,
    intersectionWithKey3,
    intersectionWithKey4,
    intersectionWithKey5,

    -- * Traversal

    -- ** Map
    mapDeep,
    mapDeepWithKey,
    mapWithKey1,
    mapWithKey2,
    mapWithKey3,
    mapWithKey4,
    mapWithKey5,
    traverseDeep,
    traverseDeepWithKey,
    traverseWithKey1,
    traverseWithKey2,
    traverseWithKey3,
    traverseWithKey4,
    traverseWithKey5,
    traverseMaybeWithKey,
    traverseMaybeWithKey1,
    traverseMaybeWithKey2,
    traverseMaybeWithKey3,
    traverseMaybeWithKey4,
    traverseMaybeWithKey5,
    mapAccum,
    mapAccum1,
    mapAccumR,
    mapAccumR1,
    mapAccumWithKey,
    mapAccumWithKey1,
    mapAccumWithKey2,
    mapAccumWithKey3,
    mapAccumWithKey4,
    mapAccumWithKey5,
    mapAccumRWithKey,
    mapAccumRWithKey1,
    mapAccumRWithKey2,
    mapAccumRWithKey3,
    mapAccumRWithKey4,
    mapAccumRWithKey5,
    mapKeys,
    mapKeys1,
    mapKeys2,
    mapKeys3,
    mapKeys4,
    mapKeys5,
    mapKeysWith,
    mapKeysWith1,
    mapKeysWith2,
    mapKeysWith3,
    mapKeysWith4,
    mapKeysWith5,
    traverseKeys,
    traverseKeysWith,
    mapKeysM,
    mapKeysM1,
    mapKeysM2,
    mapKeysM3,
    mapKeysM4,
    mapKeysM5,
    mapKeysMWith,
    mapKeysMWith1,
    mapKeysMWith2,
    mapKeysMWith3,
    mapKeysMWith4,
    mapKeysMWith5,

    -- * Folds
    foldr,
    foldl,
    foldNest,
    foldrWithKey,
    foldrWithKey1,
    foldrWithKey2,
    foldrWithKey3,
    foldrWithKey4,
    foldrWithKey5,
    foldlWithKey,
    foldlWithKey1,
    foldlWithKey2,
    foldlWithKey3,
    foldlWithKey4,
    foldlWithKey5,
    foldMapWithKey,
    foldMapWithKey1,
    foldMapWithKey2,
    foldMapWithKey3,
    foldMapWithKey4,
    foldMapWithKey5,

    -- ** Strict folds
    foldr',
    foldl',
    foldrWithKey',
    foldrWithKey1',
    foldrWithKey2',
    foldrWithKey3',
    foldrWithKey4',
    foldrWithKey5',
    foldlWithKey',
    foldlWithKey1',
    foldlWithKey2',
    foldlWithKey3',
    foldlWithKey4',
    foldlWithKey5',
    foldMapWithKey',
    foldMapWithKey1',
    foldMapWithKey2',
    foldMapWithKey3',
    foldMapWithKey4',
    foldMapWithKey5',

    -- * Conversion
    elems,
    elems1,
    keys,
    assocs,
    assocs1,
    keysSet,
    invertKeys,

    -- ** Lists
    toList,

    -- *** Ordered lists
    toAscList,
    toDescList,

    -- * Filter
    filter,
    filter1,
    filter2,
    filter3,
    filter4,
    filter5,
    filterWithKey,
    filterWithKey1,
    filterWithKey2,
    filterWithKey3,
    filterWithKey4,
    filterWithKey5,
    restrictKeys,
    restrictKeys2,
    restrictKeys3,
    restrictKeys4,
    restrictKeys5,
    withoutKeys,
    withoutKeys2,
    withoutKeys3,
    withoutKeys4,
    withoutKeys5,
    partition,
    partition1,
    partition2,
    partition3,
    partition4,
    partition5,
    partitionWithKey,
    partitionWithKey1,
    partitionWithKey2,
    partitionWithKey3,
    partitionWithKey4,
    partitionWithKey5,
    takeWhileAntitone,
    dropWhileAntitone,
    spanAntitone,
    fmapMaybe,
    mapDeepMaybe,
    mapDeepMaybeWithKey,
    mapDeepMaybeWithKey1,
    mapDeepMaybeWithKey2,
    mapDeepMaybeWithKey3,
    mapDeepMaybeWithKey4,
    mapDeepMaybeWithKey5,
    mapEither,
    mapEither1,
    mapEither2,
    mapEither3,
    mapEither4,
    mapEither5,
    mapEitherWithKey,
    mapEitherWithKey1,
    mapEitherWithKey2,
    mapEitherWithKey3,
    mapEitherWithKey4,
    mapEitherWithKey5,
    split,
    splitLookup,
    splitRoot,

    -- * Submap
    isSubmapOf,
    isSubmapOfBy,
    isProperSubmapOf,
    isProperSubmapOfBy,

    -- * Indexed
    lookupIndex,
    findIndex,
    elemAt,
    updateAt,
    deleteAt,
    take,
    drop,
    splitAt,

    -- * Min\/Max
    lookupMin,
    lookupMax,
    findMin,
    findMax,
    deleteMin,
    deleteMax,
    deleteFindMin,
    deleteFindMax,
    updateMin,
    updateMax,
    updateMinWithKey,
    updateMaxWithKey,
    minView,
    maxView,
    minViewWithKey,
    maxViewWithKey,
) where

import Control.Monad.Toolbox hiding (empty)
import Data.Data
import Data.Either.Toolbox
import Data.Foldable.Toolbox (Foldable (fold, foldl', foldr', toList))
import Data.Function.Toolbox
import Data.Functor.Compose
import Data.Functor.Identity
import Data.Map.Monoidal.Strict (Map)
import qualified Data.Map.Monoidal.Strict as Map
import qualified Data.Map.Strict as OverwritingMap
import Data.Maybe
import Data.Set (Set)
import qualified Data.Set as Set
import Data.Tuple.Toolbox
import GHC.Generics
import Prelude hiding (
    drop,
    filter,
    lookup,
    map,
    null,
    splitAt,
    take,
 )

data DeepMap (ks :: [*]) (v :: *) :: * where
    Bare :: v -> DeepMap '[] v
    Nest :: Map k (DeepMap ks v) -> DeepMap (k ': ks) v

instance (Eq v) => Eq (DeepMap '[] v) where
    Bare v1 == Bare v2 = v1 == v2
instance (Eq k, Eq (DeepMap ks v)) => Eq (DeepMap (k ': ks) v) where
    Nest v1 == Nest v2 = v1 == v2

instance (Ord v) => Ord (DeepMap '[] v) where
    Bare v1 <= Bare v2 = v1 <= v2
instance (Ord k, Ord (DeepMap ks v)) => Ord (DeepMap (k ': ks) v) where
    Nest v1 <= Nest v2 = v1 <= v2

instance (Show v) => Show (DeepMap '[] v) where
    show (Bare v) = "Bare " <> show v
instance (Show k, Show (DeepMap ks v)) => Show (DeepMap (k ': ks) v) where
    show (Nest v) = "Nest {" <> show v <> "}"

instance (Semigroup v) => Semigroup (DeepMap '[] v) where
    (<>) = onBare2 (<>)
instance (Ord k, Semigroup (DeepMap ks v)) => Semigroup (DeepMap (k ': ks) v) where
    (<>) = onNest2 (<>)

instance (Monoid v) => Monoid (DeepMap '[] v) where
    mempty = Bare mempty

instance (Ord k, Semigroup (DeepMap ks v)) => Monoid (DeepMap (k ': ks) v) where
    mempty = Nest mempty

deriving instance Functor (DeepMap ks)
deriving instance Foldable (DeepMap ks)
deriving instance Traversable (DeepMap ks)

deriving instance (Typeable v) => Typeable (DeepMap '[] v)
deriving instance (Typeable k, Typeable (DeepMap ks v)) => Typeable (DeepMap (k ': ks) v)

tyDeepMap :: DataType
tyDeepMap = mkDataType "Data.Map.Monoidal.Deep.DeepMap" [conBare, conNest]

conBare, conNest :: Constr
conBare = mkConstr tyDeepMap "Bare" [] Data.Data.Prefix
conNest = mkConstr tyDeepMap "Nest" [] Data.Data.Prefix

instance (Data v) => Data (DeepMap '[] v) where
    dataTypeOf _ = tyDeepMap
    toConstr (Bare _) = conBare
    gunfold k z _ = k (z Bare)
instance (Ord k, Data k, Typeable ks, Typeable v, Data (DeepMap ks v)) => Data (DeepMap (k ': ks) v) where
    dataTypeOf _ = tyDeepMap
    toConstr (Nest _) = conNest
    gunfold k z _ = k (z Nest)

type family RepDM (ks :: [*]) v where
    RepDM '[] v = Const v
    RepDM (k ': ks) v = Compose [] (Const k :*: RepDM ks v)

instance (Generic v) => Generic (DeepMap '[] v) where
    type Rep (DeepMap '[] v) = RepDM '[] v
    from (Bare v) = Const v
    to (Const v) = Bare v
instance (Ord k, Generic k, Generic (DeepMap ks v), Rep (DeepMap ks v) ~ RepDM ks v) => Generic (DeepMap (k ': ks) v) where
    type Rep (DeepMap (k ': ks) v) = RepDM (k ': ks) v
    from m = Compose $ (\(k, dm) -> Const k :*: from dm) <$> assocs m
    to (Compose kvs) =
        Nest . Map.Map . OverwritingMap.fromList $
            (\(Const k :*: dm') -> (k, to dm')) <$> kvs

-- | Unwrap the value of a zero-depth 'DeepMap'.
getBare :: DeepMap '[] v -> v
getBare (Bare v) = v

-- | Apply a two-argument function through a shallow 'DeepMap', akin to 'liftA2'.
onBare2 :: (v -> w -> x) -> DeepMap '[] v -> DeepMap '[] w -> DeepMap '[] x
onBare2 f (Bare v) (Bare w) = Bare $ f v w

-- | Apply a two-argument function through a shallow 'DeepMap', akin to 'liftA2'.
onBare2F :: (Functor f) => (v -> w -> f x) -> DeepMap '[] v -> DeepMap '[] w -> f (DeepMap '[] x)
onBare2F f (Bare v) (Bare w) = Bare <$> f v w

-- | Unwrap the outer layer of a 'DeepMap'.
getNest :: DeepMap (k ': ks) v -> Map k (DeepMap ks v)
getNest (Nest m) = m

-- | Apply a two-argument 'Map' function through a deep 'DeepMap', akin to 'liftA2'.
onNest2 :: (Map k (DeepMap ks v) -> Map k (DeepMap ls w) -> Map k (DeepMap ms x)) -> DeepMap (k ': ks) v -> DeepMap (k ': ls) w -> DeepMap (k ': ms) x
onNest2 f (Nest v) (Nest w) = Nest $ f v w

-- | Half of the isomorphism of a depth-1 'DeepMap' to a monoidal 'Data.Map.Monoidal.Strict.Map'. See also 'fromMonoidalMap'.
toMonoidalMap :: DeepMap '[k] v -> Map k v
toMonoidalMap (Nest m) = getBare <$> m

-- | Half of the isomorphism of a depth-1 'DeepMap' to a monoidal 'Data.Map.Monoidal.Strict.Map'. See also 'toMonoidalMap'.
fromMonoidalMap :: Map k v -> DeepMap '[k] v
fromMonoidalMap m = Nest $ Bare <$> m

-- | Half of the isomorphism of a depth-1 'DeepMap' to a 'Data.Map.Strict.Map'. See also 'fromMap'.
toMap :: DeepMap '[k] v -> OverwritingMap.Map k v
toMap (Nest m) = Map.unMap $ getBare <$> m

-- | Half of the isomorphism of a depth-1 'DeepMap' to a 'Data.Map.Strict.Map'. See also 'toMap'.
fromMap :: OverwritingMap.Map k v -> DeepMap '[k] v
fromMap m = Nest $ Bare <$> Map.Map m

-- | A singleton 'DeepMap'. Use with '(@|)' to create deep nestings:
--
-- >>> "Outer" @> 0 @| [5]
-- Nest {Map {unMap = fromList [("Outer",Nest {Map {unMap = fromList [(0,Bare [5])]}})]}}
infixr 6 @>

(@>) :: k -> DeepMap ks v -> DeepMap (k ': ks) v
k @> a = Nest $ Map.singleton k a
{-# INLINE (@>) #-}

-- | Infix synonym for 'singleton'. Use with '(@>)' to create deep nestings:
--
-- >>> "Outer" @> 0 @| [5]
-- Nest {Map {unMap = fromList [("Outer",Nest {Map {unMap = fromList [(0,Bare [5])]}})]}}
infixr 6 @|

(@|) :: k -> v -> DeepMap '[k] v
k @| a = Nest . Map.singleton k $ Bare a
{-# INLINE (@|) #-}

-- | /O(1)/. The empty, arbitrary positive-depth 'DeepMap'.
empty :: DeepMap (k ': ks) v
empty = Nest Map.empty

-- | /O(1)/. A depth-1 'DeepMap' with a single key/value pair.
singleton :: k -> v -> DeepMap '[k] v
singleton k v = Nest . Map.singleton k $ Bare v

-- | /O(n)/. Return all submaps of the map in ascending order of its keys. Subject to list fusion.
elems :: DeepMap (k ': ks) v -> [DeepMap ks v]
elems (Nest m) = Map.elems m

-- | /O(n)/. Return all values of the singly-nested map in ascending order of its keys. Subject to list fusion.
elems1 :: DeepMap '[k] v -> [v]
elems1 m = getBare <$> elems m

-- | /O(n)/. Return all keys of the map in ascending order. Subject to list fusion.
keys :: DeepMap (k ': ks) v -> [k]
keys (Nest m) = Map.keys m

-- | /O(n)/. Return all pairs of the map in ascending key order. Subject to list fusion.
assocs :: DeepMap (k ': ks) v -> [(k, DeepMap ks v)]
assocs (Nest m) = Map.assocs m

-- | /O(n)/. Return all pairs of the singly-nested map in ascending key order. Subject to list fusion.
assocs1 :: DeepMap '[k] v -> [(k, v)]
assocs1 dm = getBare <<$>> assocs dm

-- | /O(n)/. The set of all keys of the map.
keysSet :: DeepMap (k ': ks) v -> Set k
keysSet (Nest m) = Map.keysSet m

-- | /O(n log n)/. Build a deeper 'DeepMap' from a list of key/'DeepMap' pairs.
--   If the list contains more than one value for the same key,
--   the values are combined using '(<>)'.
fromList :: (Ord k, Semigroup (DeepMap ks v)) => [(k, DeepMap ks v)] -> DeepMap (k ': ks) v
fromList kvs = Nest $ Map.fromList kvs

-- | /O(n log n)/. Build a depth-1 'DeepMap' from a list of key/value pairs.
--   If the list contains more than one value for the same key,
--   the values are combined using '(<>)'.
fromList1 :: (Ord k, Semigroup v) => [(k, v)] -> DeepMap '[k] v
fromList1 kvs = foldMap (uncurry (@|)) kvs

-- | /O(n log n)/. Build a depth-2 'DeepMap' from a list of keys and values.
--   If the list contains more than one value for the same keys,
--   the values are combined using '(<>)'.
fromList2 :: (Ord k0, Ord k1, Semigroup v) => [(k0, k1, v)] -> DeepMap '[k0, k1] v
fromList2 kvs = foldMap (\(k0, k1, v) -> k0 @> k1 @| v) kvs

-- | /O(n log n)/. Build a depth-3 'DeepMap' from a list of keys and values.
--   If the list contains more than one value for the same keys,
--   the values are combined using '(<>)'.
fromList3 :: (Ord k0, Ord k1, Ord k2, Semigroup v) => [(k0, k1, k2, v)] -> DeepMap '[k0, k1, k2] v
fromList3 kvs = foldMap (\(k0, k1, k2, v) -> k0 @> k1 @> k2 @| v) kvs

-- | /O(n log n)/. Build a depth-4 'DeepMap' from a list of keys and values.
--   If the list contains more than one value for the same keys,
--   the values are combined using '(<>)'.
fromList4 :: (Ord k0, Ord k1, Ord k2, Ord k3, Semigroup v) => [(k0, k1, k2, k3, v)] -> DeepMap '[k0, k1, k2, k3] v
fromList4 kvs = foldMap (\(k0, k1, k2, k3, v) -> k0 @> k1 @> k2 @> k3 @| v) kvs

-- | /O(n log n)/. Build a depth-5 'DeepMap' from a list of keys and values.
--   If the list contains more than one value for the same keys,
--   the values are combined using '(<>)'.
fromList5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4, Semigroup v) => [(k0, k1, k2, k3, k4, v)] -> DeepMap '[k0, k1, k2, k3, k4] v
fromList5 kvs = foldMap (\(k0, k1, k2, k3, k4, v) -> k0 @> k1 @> k2 @> k3 @> k4 @| v) kvs

-- | /O(n log n)/. Build a deeper 'DeepMap' from a list of key/'DeepMap' pairs
--   using the provided combining function.
fromListWith :: (Ord k) => (DeepMap ks v -> DeepMap ks v -> DeepMap ks v) -> [(k, DeepMap ks v)] -> DeepMap (k ': ks) v
fromListWith f kvs = Nest $ Map.fromListWith f kvs

-- | /O(n log n)/. Build a depth-1 'DeepMap' from a list of key/value pairs
--   using the provided combining function.
fromListWith1 :: (Ord k) => (v -> v -> v) -> [(k, v)] -> DeepMap '[k] v
fromListWith1 f kvs = fromMonoidalMap $ Map.fromListWith f kvs

-- | /O(n log n)/. Build a deeper 'DeepMap' from a list of key/'DeepMap' pairs with a combining function.
fromListWithKey :: (Ord k) => (k -> DeepMap ks v -> DeepMap ks v -> DeepMap ks v) -> [(k, DeepMap ks v)] -> DeepMap (k ': ks) v
fromListWithKey f kvs = Nest $ Map.fromListWithKey f kvs

-- | /O(n log n)/. Build a depth-1 'DeepMap' from a list of key/value pairs with a combining function.
fromListWithKey1 :: (Ord k) => (k -> v -> v -> v) -> [(k, v)] -> DeepMap '[k] v
fromListWithKey1 f kvs = fromMonoidalMap $ Map.fromListWithKey f kvs

-- | /O(n log n)/. Build a depth-2 'DeepMap' from a list of keys and values with a combining function.
fromListWithKey2 :: (Ord k0, Ord k1) => (k0 -> k1 -> v -> v -> v) -> [(k0, k1, v)] -> DeepMap '[k0, k1] v
fromListWithKey2 f kvs =
    fromListWithKey (unionWithKey1 . f) $
        (\(k0, k1, v) -> (k0, k1 @| v)) <$> kvs

-- | /O(n log n)/. Build a depth-3 'DeepMap' from a list of keys and values with a combining function.
fromListWithKey3 :: (Ord k0, Ord k1, Ord k2) => (k0 -> k1 -> k2 -> v -> v -> v) -> [(k0, k1, k2, v)] -> DeepMap '[k0, k1, k2] v
fromListWithKey3 f kvs =
    fromListWithKey (unionWithKey2 . f) $
        (\(k0, k1, k2, v) -> (k0, k1 @> k2 @| v)) <$> kvs

-- | /O(n log n)/. Build a depth-3 'DeepMap' from a list of keys and values with a combining function.
fromListWithKey4 :: (Ord k0, Ord k1, Ord k2, Ord k3) => (k0 -> k1 -> k2 -> k3 -> v -> v -> v) -> [(k0, k1, k2, k3, v)] -> DeepMap '[k0, k1, k2, k3] v
fromListWithKey4 f kvs =
    fromListWithKey (unionWithKey3 . f) $
        (\(k0, k1, k2, k3, v) -> (k0, k1 @> k2 @> k3 @| v)) <$> kvs

-- | /O(n log n)/. Build a depth-3 'DeepMap' from a list of keys and values with a combining function.
fromListWithKey5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => (k0 -> k1 -> k2 -> k3 -> k4 -> v -> v -> v) -> [(k0, k1, k2, k3, k4, v)] -> DeepMap '[k0, k1, k2, k3, k4] v
fromListWithKey5 f kvs =
    fromListWithKey (unionWithKey4 . f) $
        (\(k0, k1, k2, k3, k4, v) -> (k0, k1 @> k2 @> k3 @> k4 @| v)) <$> kvs

-- | /O(log n)/. Insert a key/'DeepMap' pair into the 'DeepMap'. If the key is already
--   present in the map, the associated value is combined with the new value as @old '<>' new@.
--   The overwriting behaviour from @containers@ can be recovered
--   by wrapping values in 'Data.Semigroup.Last' or by using 'overwrite'.
insert :: (Ord k, Semigroup (DeepMap ks v)) => k -> DeepMap ks v -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
insert k dm (Nest m) = Nest $ Map.insertWith (flip (<>)) k dm m

-- | /O(log n)/. Insert a new key and value into a depth-1 'DeepMap'. If the key is already
--   present in the map, the associated value is combined with the new value as @old '<>' new@.
--   The overwriting behaviour from @containers@ can be recovered
--   by wrapping values in 'Data.Semigroup.Last' or by using 'overwrite1'.
insert1 :: (Ord k, Semigroup v) => k -> v -> DeepMap '[k] v -> DeepMap '[k] v
insert1 k v m = m <> k @| v

-- | /O(log n)/. Insert a new key-chain/value pair into a depth-2 'DeepMap'. If the key is already
--   present in the map, the associated value is combined with the new value as @old '<>' new@.
--   The overwriting behaviour from @containers@ can be recovered
--   by wrapping values in 'Data.Semigroup.Last' or by using 'overwrite2'.
insert2 :: (Ord k0, Ord k1, Semigroup v) => k0 -> k1 -> v -> DeepMap '[k0, k1] v -> DeepMap '[k0, k1] v
insert2 k0 k1 v m = m <> k0 @> k1 @| v

-- | /O(log n)/. Insert a new key-chain/value pair into a depth-3 'DeepMap'. If the key is already
--   present in the map, the associated value is combined with the new value as @old '<>' new@.
--   so the overwriting behaviour from @containers@ can be recovered
--   by wrapping values in 'Data.Semigroup.Last' or by using 'overwrite3'.
insert3 :: (Ord k0, Ord k1, Ord k2, Semigroup v) => k0 -> k1 -> k2 -> v -> DeepMap '[k0, k1, k2] v -> DeepMap '[k0, k1, k2] v
insert3 k0 k1 k2 v m = m <> k0 @> k1 @> k2 @| v

-- | /O(log n)/. Insert a new key-chain/value pair into a depth-4 'DeepMap'. If the key is already
--   present in the map, the associated value is combined with the new value as @old '<>' new@.
--   so the overwriting behaviour from @containers@ can be recovered
--   by wrapping values in 'Data.Semigroup.Last' or by using 'overwrite4'.
insert4 :: (Ord k0, Ord k1, Ord k2, Ord k3, Semigroup v) => k0 -> k1 -> k2 -> k3 -> v -> DeepMap '[k0, k1, k2, k3] v -> DeepMap '[k0, k1, k2, k3] v
insert4 k0 k1 k2 k3 v m = m <> k0 @> k1 @> k2 @> k3 @| v

-- | /O(log n)/. Insert a new key-chain/value pair into a depth-5 'DeepMap'. If the key is already
--   present in the map, the associated value is combined with the new value as @old '<>' new@.
--   so the overwriting behaviour from @containers@ can be recovered
--   by wrapping values in 'Data.Semigroup.Last' or by using 'overwrite5'.
insert5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4, Semigroup v) => k0 -> k1 -> k2 -> k3 -> k4 -> v -> DeepMap '[k0, k1, k2, k3, k4] v -> DeepMap '[k0, k1, k2, k3, k4] v
insert5 k0 k1 k2 k3 k4 v m = m <> k0 @> k1 @> k2 @> k3 @> k4 @| v

-- | /O(log n)/. Insert a new key/'DeepMap' pair into the 'DeepMap'. If the key is already
--   present in the map, the associated value is replaced by the new value.
overwrite :: (Ord k) => k -> DeepMap ks v -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
overwrite k v (Nest m) = Nest . Map.Map $ OverwritingMap.insert k v (Map.unMap m)

-- | /O(log n)/. Insert a new key/value pair into a depth-1 'DeepMap'. If the key is already
--   present in the map, the associated value is replaced by the new value.
overwrite1 :: (Ord k) => k -> v -> DeepMap '[k] v -> DeepMap '[k] v
overwrite1 k v m = overwrite k (Bare v) m

-- | /O(log n)/. Insert a new key-chain/value pair into a depth-2 'DeepMap'. If the key is already
--   present in the map, the associated value is replaced by the new value.
overwrite2 :: (Ord k0, Ord k1) => k0 -> k1 -> v -> DeepMap '[k0, k1] v -> DeepMap '[k0, k1] v
overwrite2 k0 k1 v m = overwrite k0 (overwrite k1 (Bare v) . fromMaybe empty $ m @? k0) m

-- | /O(log n)/. Insert a new key-chain/value pair into a depth-3 'DeepMap'. If the key is already
--   present in the map, the associated value is replaced by the new value.
overwrite3 :: (Ord k0, Ord k1, Ord k2) => k0 -> k1 -> k2 -> v -> DeepMap '[k0, k1, k2] v -> DeepMap '[k0, k1, k2] v
overwrite3 k0 k1 k2 v m = overwrite k0 (overwrite2 k1 k2 v . fromMaybe empty $ m @? k0) m

-- | /O(log n)/. Insert a new key-chain/value pair into a depth-4 'DeepMap'. If the key is already
--   present in the map, the associated value is replaced by the new value.
overwrite4 :: (Ord k0, Ord k1, Ord k2, Ord k3) => k0 -> k1 -> k2 -> k3 -> v -> DeepMap '[k0, k1, k2, k3] v -> DeepMap '[k0, k1, k2, k3] v
overwrite4 k0 k1 k2 k3 v m = overwrite k0 (overwrite3 k1 k2 k3 v . fromMaybe empty $ m @? k0) m

-- | /O(log n)/. Insert a new key-chain/value pair into a depth-5 'DeepMap'. If the key is already
--   present in the map, the associated value is replaced by the new value.
overwrite5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => k0 -> k1 -> k2 -> k3 -> k4 -> v -> DeepMap '[k0, k1, k2, k3, k4] v -> DeepMap '[k0, k1, k2, k3, k4] v
overwrite5 k0 k1 k2 k3 k4 v m = overwrite k0 (overwrite4 k1 k2 k3 k4 v . fromMaybe empty $ m @? k0) m

-- | /O(log n)/. Combines replacement and retrieval.
overwriteLookup :: (Ord k) => k -> DeepMap ks v -> DeepMap (k ': ks) v -> (Maybe (DeepMap ks v), DeepMap (k ': ks) v)
overwriteLookup k v (Nest m) = Nest <$> Map.insertLookupWithKey (const const) k v m

-- | /O(log n)/. Combines replacement and retrieval at depth 1.
overwriteLookup1 :: (Ord k) => k -> v -> DeepMap '[k] v -> (Maybe v, DeepMap '[k] v)
overwriteLookup1 k v m = (m @?| k, overwrite1 k v m)

-- | /O(log n)/. Combines replacement and retrieval at depth 2.
overwriteLookup2 :: (Ord k0, Ord k1) => k0 -> k1 -> v -> DeepMap '[k0, k1] v -> (Maybe v, DeepMap '[k0, k1] v)
overwriteLookup2 k0 k1 v m = (m @? k0 @??| k1, overwrite2 k0 k1 v m)

-- | /O(log n)/. Combines replacement and retrieval at depth 3.
overwriteLookup3 :: (Ord k0, Ord k1, Ord k2) => k0 -> k1 -> k2 -> v -> DeepMap '[k0, k1, k2] v -> (Maybe v, DeepMap '[k0, k1, k2] v)
overwriteLookup3 k0 k1 k2 v m = (m @? k0 @?? k1 @??| k2, overwrite3 k0 k1 k2 v m)

-- | /O(log n)/. Combines replacement and retrieval at depth 4.
overwriteLookup4 :: (Ord k0, Ord k1, Ord k2, Ord k3) => k0 -> k1 -> k2 -> k3 -> v -> DeepMap '[k0, k1, k2, k3] v -> (Maybe v, DeepMap '[k0, k1, k2, k3] v)
overwriteLookup4 k0 k1 k2 k3 v m = (m @? k0 @?? k1 @?? k2 @??| k3, overwrite4 k0 k1 k2 k3 v m)

-- | /O(log n)/. Combines replacement and retrieval at depth 5.
overwriteLookup5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => k0 -> k1 -> k2 -> k3 -> k4 -> v -> DeepMap '[k0, k1, k2, k3, k4] v -> (Maybe v, DeepMap '[k0, k1, k2, k3, k4] v)
overwriteLookup5 k0 k1 k2 k3 k4 v m = (m @? k0 @?? k1 @?? k2 @?? k3 @??| k4, overwrite5 k0 k1 k2 k3 k4 v m)

-- | /O(log n)/. Insert with a function, combining new value and old value
--   using the supplied function.
--
--   @'insertWith' (~~) k new m@ will insert @new@ at @k@ if there is no value present,
--   or overwrite with @old ~~ new@ if there was already a value @old@ at @k@.
insertWith :: (Ord k) => (DeepMap ks v -> DeepMap ks v -> DeepMap ks v) -> k -> DeepMap ks v -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
insertWith f k v (Nest m) = Nest $ Map.insertWith f k v m

-- | /O(log n)/. Insert with a function, combining new value and old value
--   using the supplied function.
--
--   @'insertWith1' (~~) k new m@ will insert @new@ at @k@ if there is no value present,
--   or overwrite with @old ~~ new@ if there was already a value @old@ at @k@.
insertWith1 :: (Ord k) => (v -> v -> v) -> k -> v -> DeepMap '[k] v -> DeepMap '[k] v
insertWith1 f k v m = insertWith (onBare2 f) k (Bare v) m

-- | /O(log n)/. Insert with a function, combining new value and old value
--   using the supplied function.
insertWith2 :: (Ord k0, Ord k1) => (v -> v -> v) -> k0 -> k1 -> v -> DeepMap '[k0, k1] v -> DeepMap '[k0, k1] v
insertWith2 f k0 k1 v m = case m @? k0 of
    Nothing -> overwrite2 k0 k1 v m
    Just dm -> overwrite k0 (insertWith1 f k1 v dm) m

-- | /O(log n)/. Insert with a function, combining new value and old value
--   using the supplied function.
insertWith3 :: (Ord k0, Ord k1, Ord k2) => (v -> v -> v) -> k0 -> k1 -> k2 -> v -> DeepMap '[k0, k1, k2] v -> DeepMap '[k0, k1, k2] v
insertWith3 f k0 k1 k2 v m = case m @? k0 of
    Nothing -> overwrite3 k0 k1 k2 v m
    Just dm -> overwrite k0 (insertWith2 f k1 k2 v dm) m

-- | /O(log n)/. Insert with a function, combining new value and old value
--   using the supplied function.
insertWith4 :: (Ord k0, Ord k1, Ord k2, Ord k3) => (v -> v -> v) -> k0 -> k1 -> k2 -> k3 -> v -> DeepMap '[k0, k1, k2, k3] v -> DeepMap '[k0, k1, k2, k3] v
insertWith4 f k0 k1 k2 k3 v m = case m @? k0 of
    Nothing -> overwrite4 k0 k1 k2 k3 v m
    Just dm -> overwrite k0 (insertWith3 f k1 k2 k3 v dm) m

-- | /O(log n)/. Insert with a function, combining new value and old value
--   using the supplied function.
insertWith5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => (v -> v -> v) -> k0 -> k1 -> k2 -> k3 -> k4 -> v -> DeepMap '[k0, k1, k2, k3, k4] v -> DeepMap '[k0, k1, k2, k3, k4] v
insertWith5 f k0 k1 k2 k3 k4 v m = case m @? k0 of
    Nothing -> overwrite5 k0 k1 k2 k3 k4 v m
    Just dm -> overwrite k0 (insertWith4 f k1 k2 k3 k4 v dm) m

-- | /O(log n)/. Insert with a function, combining new value and old value
--   using the supplied function.
--
--   @'insertWithKey' f k new m@ will insert @new@ at @k@ if there is no value present,
--   or @f k old new@ if there was already a value @old@ at @k@.
--   The key passed to @f@ is the one passed to 'insertWithKey', not the one present in the map.
insertWithKey :: (Ord k) => (k -> DeepMap ks v -> DeepMap ks v -> DeepMap ks v) -> k -> DeepMap ks v -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
insertWithKey f k v (Nest m) = Nest $ Map.insertWithKey f k v m

-- | /O(log n)/. Insert with a function, combining new value and old value
--   using the supplied function with access to the given keys.
insertWithKey1 :: (Ord k) => (k -> v -> v -> v) -> k -> v -> DeepMap '[k] v -> DeepMap '[k] v
insertWithKey1 f k v m = insertWithKey (onBare2 . f) k (Bare v) m

-- | /O(log n)/. Insert with a function, combining new value and old value
--   using the supplied function with access to the given keys.
insertWithKey2 :: (Ord k0, Ord k1) => (k0 -> k1 -> v -> v -> v) -> k0 -> k1 -> v -> DeepMap '[k0, k1] v -> DeepMap '[k0, k1] v
insertWithKey2 f k0 k1 v m = case m @? k0 of
    Nothing -> overwrite2 k0 k1 v m
    Just dm -> overwrite k0 (insertWithKey1 (f k0) k1 v dm) m

-- | /O(log n)/. Insert with a function, combining new value and old value
--   using the supplied function with access to the given keys.
insertWithKey3 :: (Ord k0, Ord k1, Ord k2) => (k0 -> k1 -> k2 -> v -> v -> v) -> k0 -> k1 -> k2 -> v -> DeepMap '[k0, k1, k2] v -> DeepMap '[k0, k1, k2] v
insertWithKey3 f k0 k1 k2 v m = case m @? k0 of
    Nothing -> overwrite3 k0 k1 k2 v m
    Just dm -> overwrite k0 (insertWithKey2 (f k0) k1 k2 v dm) m

-- | /O(log n)/. Insert with a function, combining new value and old value
--   using the supplied function with access to the given keys.
insertWithKey4 :: (Ord k0, Ord k1, Ord k2, Ord k3) => (k0 -> k1 -> k2 -> k3 -> v -> v -> v) -> k0 -> k1 -> k2 -> k3 -> v -> DeepMap '[k0, k1, k2, k3] v -> DeepMap '[k0, k1, k2, k3] v
insertWithKey4 f k0 k1 k2 k3 v m = case m @? k0 of
    Nothing -> overwrite4 k0 k1 k2 k3 v m
    Just dm -> overwrite k0 (insertWithKey3 (f k0) k1 k2 k3 v dm) m

-- | /O(log n)/. Insert with a function, combining new value and old value
--   using the supplied function with access to the given keys.
insertWithKey5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => (k0 -> k1 -> k2 -> k3 -> k4 -> v -> v -> v) -> k0 -> k1 -> k2 -> k3 -> k4 -> v -> DeepMap '[k0, k1, k2, k3, k4] v -> DeepMap '[k0, k1, k2, k3, k4] v
insertWithKey5 f k0 k1 k2 k3 k4 v m = case m @? k0 of
    Nothing -> overwrite5 k0 k1 k2 k3 k4 v m
    Just dm -> overwrite k0 (insertWithKey4 (f k0) k1 k2 k3 k4 v dm) m

-- | /O(log n)/. Combines insertion and retrieval.
--
-- > 'insertLookupWithKey' f k new == 'lookup' k &&& 'insertWithKey' f k new
insertLookupWithKey :: (Ord k) => (k -> DeepMap ks v -> DeepMap ks v -> DeepMap ks v) -> k -> DeepMap ks v -> DeepMap (k ': ks) v -> (Maybe (DeepMap ks v), DeepMap (k ': ks) v)
insertLookupWithKey f k v (Nest m) = Nest <$> Map.insertLookupWithKey f k v m

-- | /O(log n)/. Combines insertion and retrieval.
insertLookupWithKey1 :: (Ord k) => (k -> v -> v -> v) -> k -> v -> DeepMap '[k] v -> (Maybe v, DeepMap '[k] v)
insertLookupWithKey1 f k v m = (m @?| k, insertWithKey1 f k v m)

-- | /O(log n)/. Combines insertion and retrieval.
insertLookupWithKey2 :: (Ord k0, Ord k1) => (k0 -> k1 -> v -> v -> v) -> k0 -> k1 -> v -> DeepMap '[k0, k1] v -> (Maybe v, DeepMap '[k0, k1] v)
insertLookupWithKey2 f k0 k1 v m = (m @? k0 @??| k1, insertWithKey2 f k0 k1 v m)

-- | /O(log n)/. Combines insertion and retrieval.
insertLookupWithKey3 :: (Ord k0, Ord k1, Ord k2) => (k0 -> k1 -> k2 -> v -> v -> v) -> k0 -> k1 -> k2 -> v -> DeepMap '[k0, k1, k2] v -> (Maybe v, DeepMap '[k0, k1, k2] v)
insertLookupWithKey3 f k0 k1 k2 v m = (m @? k0 @?? k1 @??| k2, insertWithKey3 f k0 k1 k2 v m)

-- | /O(log n)/. Combines insertion and retrieval.
insertLookupWithKey4 :: (Ord k0, Ord k1, Ord k2, Ord k3) => (k0 -> k1 -> k2 -> k3 -> v -> v -> v) -> k0 -> k1 -> k2 -> k3 -> v -> DeepMap '[k0, k1, k2, k3] v -> (Maybe v, DeepMap '[k0, k1, k2, k3] v)
insertLookupWithKey4 f k0 k1 k2 k3 v m = (m @? k0 @?? k1 @?? k2 @??| k3, insertWithKey4 f k0 k1 k2 k3 v m)

-- | /O(log n)/. Combines insertion and retrieval.
insertLookupWithKey5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => (k0 -> k1 -> k2 -> k3 -> k4 -> v -> v -> v) -> k0 -> k1 -> k2 -> k3 -> k4 -> v -> DeepMap '[k0, k1, k2, k3, k4] v -> (Maybe v, DeepMap '[k0, k1, k2, k3, k4] v)
insertLookupWithKey5 f k0 k1 k2 k3 k4 v m = (m @? k0 @?? k1 @?? k2 @?? k3 @??| k4, insertWithKey5 f k0 k1 k2 k3 k4 v m)

-- | /O(log n)/. Delete a key and its value from the map, or do nothing if the key is missing.
delete :: (Ord k) => k -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
delete k (Nest m) = Nest $ Map.delete k m

-- | /O(log n)/. Delete a key and its value from the map, or do nothing if the key is missing.
delete1 :: (Ord k) => k -> DeepMap '[k] v -> DeepMap '[k] v
delete1 = delete

-- | /O(log n)/. Delete a key and its value from the map, or do nothing if the key is missing.
delete2 :: (Ord k0, Ord k1) => k0 -> k1 -> DeepMap '[k0, k1] v -> DeepMap '[k0, k1] v
delete2 k0 k1 m = case m @? k0 of
    Nothing -> m
    Just dm -> overwrite k0 (delete1 k1 dm) m

-- | /O(log n)/. Delete a key and its value from the map, or do nothing if the key is missing.
delete3 :: (Ord k0, Ord k1, Ord k2) => k0 -> k1 -> k2 -> DeepMap '[k0, k1, k2] v -> DeepMap '[k0, k1, k2] v
delete3 k0 k1 k2 m = case m @? k0 of
    Nothing -> m
    Just dm -> overwrite k0 (delete2 k1 k2 dm) m

-- | /O(log n)/. Delete a key and its value from the map, or do nothing if the key is missing.
delete4 :: (Ord k0, Ord k1, Ord k2, Ord k3) => k0 -> k1 -> k2 -> k3 -> DeepMap '[k0, k1, k2, k3] v -> DeepMap '[k0, k1, k2, k3] v
delete4 k0 k1 k2 k3 m = case m @? k0 of
    Nothing -> m
    Just dm -> overwrite k0 (delete3 k1 k2 k3 dm) m

-- | /O(log n)/. Delete a key and its value from the map, or do nothing if the key is missing.
delete5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => k0 -> k1 -> k2 -> k3 -> k4 -> DeepMap '[k0, k1, k2, k3, k4] v -> DeepMap '[k0, k1, k2, k3, k4] v
delete5 k0 k1 k2 k3 k4 m = case m @? k0 of
    Nothing -> m
    Just dm -> overwrite k0 (delete4 k1 k2 k3 k4 dm) m

-- | /O(log n)/. Change a value at a specific key with the result of the provided function,
--   or do nothing if the key is missing.
adjust :: (Ord k) => (DeepMap ks v -> DeepMap ks v) -> k -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
adjust f k (Nest m) = Nest $ Map.adjust f k m

-- | /O(log n)/. Change a value at a specific key with the result of the provided function,
--   or do nothing if the key is missing.
adjust1 :: (Ord k) => (v -> v) -> k -> DeepMap '[k] v -> DeepMap '[k] v
adjust1 f k m = adjust (fmap f) k m

-- | /O(log n)/. Change a value at specific keys with the result of the provided function,
--   or do nothing if the key is missing.
adjust2 :: (Ord k0, Ord k1) => (v -> v) -> k0 -> k1 -> DeepMap '[k0, k1] v -> DeepMap '[k0, k1] v
adjust2 f k0 k1 m = case m @? k0 of
    Nothing -> m
    Just dm -> overwrite k0 (adjust1 f k1 dm) m

-- | /O(log n)/. Change a value at specific keys with the result of the provided function,
--   or do nothing if the key is missing.
adjust3 :: (Ord k0, Ord k1, Ord k2) => (v -> v) -> k0 -> k1 -> k2 -> DeepMap '[k0, k1, k2] v -> DeepMap '[k0, k1, k2] v
adjust3 f k0 k1 k2 m = case m @? k0 of
    Nothing -> m
    Just dm -> overwrite k0 (adjust2 f k1 k2 dm) m

-- | /O(log n)/. Change a value at specific keys with the result of the provided function,
--   or do nothing if the key is missing.
adjust4 :: (Ord k0, Ord k1, Ord k2, Ord k3) => (v -> v) -> k0 -> k1 -> k2 -> k3 -> DeepMap '[k0, k1, k2, k3] v -> DeepMap '[k0, k1, k2, k3] v
adjust4 f k0 k1 k2 k3 m = case m @? k0 of
    Nothing -> m
    Just dm -> overwrite k0 (adjust3 f k1 k2 k3 dm) m

-- | /O(log n)/. Change a value at specific keys with the result of the provided function,
--   or do nothing if the key is missing.
adjust5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => (v -> v) -> k0 -> k1 -> k2 -> k3 -> k4 -> DeepMap '[k0, k1, k2, k3, k4] v -> DeepMap '[k0, k1, k2, k3, k4] v
adjust5 f k0 k1 k2 k3 k4 m = case m @? k0 of
    Nothing -> m
    Just dm -> overwrite k0 (adjust4 f k1 k2 k3 k4 dm) m

-- | /O(log n)/. Change a value at a specific key with access to the key itself,
--   or do nothing if the key is missing.
adjustWithKey :: (Ord k) => (k -> DeepMap ks v -> DeepMap ks v) -> k -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
adjustWithKey f k (Nest m) = Nest $ Map.adjustWithKey f k m

-- | /O(log n)/. Change a value at a specific key with access to the key itself,
--   or do nothing if the key is missing.
adjustWithKey1 :: (Ord k) => (k -> v -> v) -> k -> DeepMap '[k] v -> DeepMap '[k] v
adjustWithKey1 f k m = adjustWithKey (fmap . f) k m

-- | /O(log n)/. Change a value at a specific key with access to the key itself,
--   or do nothing if the key is missing.
adjustWithKey2 :: (Ord k0, Ord k1) => (k0 -> k1 -> v -> v) -> k0 -> k1 -> DeepMap '[k0, k1] v -> DeepMap '[k0, k1] v
adjustWithKey2 f k0 k1 m = case m @? k0 of
    Nothing -> m
    Just dm -> overwrite k0 (adjustWithKey1 (f k0) k1 dm) m

-- | /O(log n)/. Change a value at a specific key with access to the key itself,
--   or do nothing if the key is missing.
adjustWithKey3 :: (Ord k0, Ord k1, Ord k2) => (k0 -> k1 -> k2 -> v -> v) -> k0 -> k1 -> k2 -> DeepMap '[k0, k1, k2] v -> DeepMap '[k0, k1, k2] v
adjustWithKey3 f k0 k1 k2 m = case m @? k0 of
    Nothing -> m
    Just dm -> overwrite k0 (adjustWithKey2 (f k0) k1 k2 dm) m

-- | /O(log n)/. Change a value at a specific key with access to the key itself,
--   or do nothing if the key is missing.
adjustWithKey4 :: (Ord k0, Ord k1, Ord k2, Ord k3) => (k0 -> k1 -> k2 -> k3 -> v -> v) -> k0 -> k1 -> k2 -> k3 -> DeepMap '[k0, k1, k2, k3] v -> DeepMap '[k0, k1, k2, k3] v
adjustWithKey4 f k0 k1 k2 k3 m = case m @? k0 of
    Nothing -> m
    Just dm -> overwrite k0 (adjustWithKey3 (f k0) k1 k2 k3 dm) m

-- | /O(log n)/. Change a value at a specific key with access to the key itself,
--   or do nothing if the key is missing.
adjustWithKey5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => (k0 -> k1 -> k2 -> k3 -> k4 -> v -> v) -> k0 -> k1 -> k2 -> k3 -> k4 -> DeepMap '[k0, k1, k2, k3, k4] v -> DeepMap '[k0, k1, k2, k3, k4] v
adjustWithKey5 f k0 k1 k2 k3 k4 m = case m @? k0 of
    Nothing -> m
    Just dm -> overwrite k0 (adjustWithKey4 (f k0) k1 k2 k3 k4 dm) m

-- | /O(log n)/. Change a 'DeepMap' at a specific key. If the function evaluates to 'Nothing',
--   the key and submap are removed. If the key is missing, do nothing.
update :: (Ord k) => (DeepMap ks v -> Maybe (DeepMap ks v)) -> k -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
update f k (Nest m) = Nest $ Map.update f k m

-- | /O(log n)/. Change a 'DeepMap' at a specific key. If the function evaluates to 'Nothing',
--   the key and submap are removed. If the key is missing, do nothing.
update1 :: (Ord k) => (v -> Maybe v) -> k -> DeepMap '[k] v -> DeepMap '[k] v
update1 f k m = update (traverse f) k m

-- | /O(log n)/. Change a 'DeepMap' at a specific key. If the function evaluates to 'Nothing',
--   the key and submap are removed. If the key is missing, do nothing.
update2 :: (Ord k0, Ord k1) => (v -> Maybe v) -> k0 -> k1 -> DeepMap '[k0, k1] v -> DeepMap '[k0, k1] v
update2 f k0 k1 m = case m @? k0 of
    Nothing -> m
    Just dm -> overwrite k0 (update1 f k1 dm) m

-- | /O(log n)/. Change a 'DeepMap' at a specific key. If the function evaluates to 'Nothing',
--   the key and submap are removed. If the key is missing, do nothing.
update3 :: (Ord k0, Ord k1, Ord k2) => (v -> Maybe v) -> k0 -> k1 -> k2 -> DeepMap '[k0, k1, k2] v -> DeepMap '[k0, k1, k2] v
update3 f k0 k1 k2 m = case m @? k0 of
    Nothing -> m
    Just dm -> overwrite k0 (update2 f k1 k2 dm) m

-- | /O(log n)/. Change a 'DeepMap' at a specific key. If the function evaluates to 'Nothing',
--   the key and submap are removed. If the key is missing, do nothing.
update4 :: (Ord k0, Ord k1, Ord k2, Ord k3) => (v -> Maybe v) -> k0 -> k1 -> k2 -> k3 -> DeepMap '[k0, k1, k2, k3] v -> DeepMap '[k0, k1, k2, k3] v
update4 f k0 k1 k2 k3 m = case m @? k0 of
    Nothing -> m
    Just dm -> overwrite k0 (update3 f k1 k2 k3 dm) m

-- | /O(log n)/. Change a 'DeepMap' at a specific key. If the function evaluates to 'Nothing',
--   the key and submap are removed. If the key is missing, do nothing.
update5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => (v -> Maybe v) -> k0 -> k1 -> k2 -> k3 -> k4 -> DeepMap '[k0, k1, k2, k3, k4] v -> DeepMap '[k0, k1, k2, k3, k4] v
update5 f k0 k1 k2 k3 k4 m = case m @? k0 of
    Nothing -> m
    Just dm -> overwrite k0 (update4 f k1 k2 k3 k4 dm) m

-- | /O(log n)/. Change a 'DeepMap' at a specific key, with access to the key itself.
--   If the function evaluates to 'Nothing', the key and submap are removed.
--   If the key is missing, do nothing.
updateWithKey :: (Ord k) => (k -> DeepMap ks v -> Maybe (DeepMap ks v)) -> k -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
updateWithKey f k (Nest m) = Nest $ Map.updateWithKey f k m

-- | /O(log n)/. Change a value at a specific key with access to the key itself.
--   If the function evaluates to 'Nothing', the key and value are removed.
--   If the key is missing, do nothing.
updateWithKey1 :: (Ord k) => (k -> v -> Maybe v) -> k -> DeepMap '[k] v -> DeepMap '[k] v
updateWithKey1 f k m = updateWithKey (traverse . f) k m

-- | /O(log n)/. Change a value at specific keys with access to the keys themselves.
--   If the function evaluates to 'Nothing', the keys and value are removed.
--   If the keys are missing, do nothing.
updateWithKey2 :: (Ord k0, Ord k1) => (k0 -> k1 -> v -> Maybe v) -> k0 -> k1 -> DeepMap '[k0, k1] v -> DeepMap '[k0, k1] v
updateWithKey2 f k0 k1 m = case m @? k0 of
    Nothing -> m
    Just dm -> overwrite k0 (updateWithKey1 (f k0) k1 dm) m

-- | /O(log n)/. Change a value at specific keys with access to the keys themselves.
--   If the function evaluates to 'Nothing', the keys and value are removed.
--   If the keys are missing, do nothing.
updateWithKey3 :: (Ord k0, Ord k1, Ord k2) => (k0 -> k1 -> k2 -> v -> Maybe v) -> k0 -> k1 -> k2 -> DeepMap '[k0, k1, k2] v -> DeepMap '[k0, k1, k2] v
updateWithKey3 f k0 k1 k2 m = case m @? k0 of
    Nothing -> m
    Just dm -> overwrite k0 (updateWithKey2 (f k0) k1 k2 dm) m

-- | /O(log n)/. Change a value at specific keys with access to the keys themselves.
--   If the function evaluates to 'Nothing', the keys and value are removed.
--   If the keys are missing, do nothing.
updateWithKey4 :: (Ord k0, Ord k1, Ord k2, Ord k3) => (k0 -> k1 -> k2 -> k3 -> v -> Maybe v) -> k0 -> k1 -> k2 -> k3 -> DeepMap '[k0, k1, k2, k3] v -> DeepMap '[k0, k1, k2, k3] v
updateWithKey4 f k0 k1 k2 k3 m = case m @? k0 of
    Nothing -> m
    Just dm -> overwrite k0 (updateWithKey3 (f k0) k1 k2 k3 dm) m

-- | /O(log n)/. Change a value at specific keys with access to the keys themselves.
--   If the function evaluates to 'Nothing', the keys and value are removed.
--   If the keys are missing, do nothing.
updateWithKey5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => (k0 -> k1 -> k2 -> k3 -> k4 -> v -> Maybe v) -> k0 -> k1 -> k2 -> k3 -> k4 -> DeepMap '[k0, k1, k2, k3, k4] v -> DeepMap '[k0, k1, k2, k3, k4] v
updateWithKey5 f k0 k1 k2 k3 k4 m = case m @? k0 of
    Nothing -> m
    Just dm -> overwrite k0 (updateWithKey4 (f k0) k1 k2 k3 k4 dm) m

-- | /O(log n)/. Combines change and retrieval.
--
-- > 'updateLookupWithKey' f k == 'lookup' k &&& 'updateWithKey' f k
updateLookupWithKey :: (Ord k) => (k -> DeepMap ks v -> Maybe (DeepMap ks v)) -> k -> DeepMap (k ': ks) v -> (Maybe (DeepMap ks v), DeepMap (k ': ks) v)
updateLookupWithKey f k (Nest m) = Nest <$> Map.updateLookupWithKey f k m

-- | /O(log n)/. Combines change and retrieval.
updateLookupWithKey1 :: (Ord k) => (k -> v -> Maybe v) -> k -> DeepMap '[k] v -> (Maybe v, DeepMap '[k] v)
updateLookupWithKey1 f k m = (m @?| k, updateWithKey1 f k m)

-- | /O(log n)/. Combines change and retrieval.
updateLookupWithKey2 :: (Ord k0, Ord k1) => (k0 -> k1 -> v -> Maybe v) -> k0 -> k1 -> DeepMap '[k0, k1] v -> (Maybe v, DeepMap '[k0, k1] v)
updateLookupWithKey2 f k0 k1 m = (m @? k0 @??| k1, updateWithKey2 f k0 k1 m)

-- | /O(log n)/. Combines change and retrieval.
updateLookupWithKey3 :: (Ord k0, Ord k1, Ord k2) => (k0 -> k1 -> k2 -> v -> Maybe v) -> k0 -> k1 -> k2 -> DeepMap '[k0, k1, k2] v -> (Maybe v, DeepMap '[k0, k1, k2] v)
updateLookupWithKey3 f k0 k1 k2 m = (m @? k0 @?? k1 @??| k2, updateWithKey3 f k0 k1 k2 m)

-- | /O(log n)/. Combines change and retrieval.
updateLookupWithKey4 :: (Ord k0, Ord k1, Ord k2, Ord k3) => (k0 -> k1 -> k2 -> k3 -> v -> Maybe v) -> k0 -> k1 -> k2 -> k3 -> DeepMap '[k0, k1, k2, k3] v -> (Maybe v, DeepMap '[k0, k1, k2, k3] v)
updateLookupWithKey4 f k0 k1 k2 k3 m = (m @? k0 @?? k1 @?? k2 @??| k3, updateWithKey4 f k0 k1 k2 k3 m)

-- | /O(log n)/. Combines change and retrieval.
updateLookupWithKey5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => (k0 -> k1 -> k2 -> k3 -> k4 -> v -> Maybe v) -> k0 -> k1 -> k2 -> k3 -> k4 -> DeepMap '[k0, k1, k2, k3, k4] v -> (Maybe v, DeepMap '[k0, k1, k2, k3, k4] v)
updateLookupWithKey5 f k0 k1 k2 k3 k4 m = (m @? k0 @?? k1 @?? k2 @?? k3 @??| k4, updateWithKey5 f k0 k1 k2 k3 k4 m)

-- | /O(log n)/. Can be used to 'insert', 'overwrite', 'delete', or 'update' a value.
alter :: (Ord k) => (Maybe (DeepMap ks v) -> Maybe (DeepMap ks v)) -> k -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
alter f k (Nest m) = Nest $ Map.alter f k m

-- | /O(log n)/. Can be used to 'insert', 'overwrite', 'delete', or 'update' a value.
alter1 :: (Ord k) => (Maybe v -> Maybe v) -> k -> DeepMap '[k] v -> DeepMap '[k] v
alter1 f k m = alter (fmap Bare . f . fmap getBare) k m

-- | /O(log n)/. Can be used to 'insert', 'overwrite', 'delete', or 'update' a value.
alter2 :: (Ord k0, Ord k1) => (Maybe v -> Maybe v) -> k0 -> k1 -> DeepMap '[k0, k1] v -> DeepMap '[k0, k1] v
alter2 f k0 k1 m = case f $ m @? k0 @??| k1 of
    Nothing -> delete2 k0 k1 m
    Just v -> overwrite2 k0 k1 v m

-- | /O(log n)/. Can be used to 'insert', 'overwrite', 'delete', or 'update' a value.
alter3 :: (Ord k0, Ord k1, Ord k2) => (Maybe v -> Maybe v) -> k0 -> k1 -> k2 -> DeepMap '[k0, k1, k2] v -> DeepMap '[k0, k1, k2] v
alter3 f k0 k1 k2 m = case f $ m @? k0 @?? k1 @??| k2 of
    Nothing -> delete3 k0 k1 k2 m
    Just v -> overwrite3 k0 k1 k2 v m

-- | /O(log n)/. Can be used to 'insert', 'overwrite', 'delete', or 'update' a value.
alter4 :: (Ord k0, Ord k1, Ord k2, Ord k3) => (Maybe v -> Maybe v) -> k0 -> k1 -> k2 -> k3 -> DeepMap '[k0, k1, k2, k3] v -> DeepMap '[k0, k1, k2, k3] v
alter4 f k0 k1 k2 k3 m = case f $ m @? k0 @?? k1 @?? k2 @??| k3 of
    Nothing -> delete4 k0 k1 k2 k3 m
    Just v -> overwrite4 k0 k1 k2 k3 v m

-- | /O(log n)/. Can be used to 'insert', 'overwrite', 'delete', or 'update' a value.
alter5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => (Maybe v -> Maybe v) -> k0 -> k1 -> k2 -> k3 -> k4 -> DeepMap '[k0, k1, k2, k3, k4] v -> DeepMap '[k0, k1, k2, k3, k4] v
alter5 f k0 k1 k2 k3 k4 m = case f $ m @? k0 @?? k1 @?? k2 @?? k3 @??| k4 of
    Nothing -> delete5 k0 k1 k2 k3 k4 m
    Just v -> overwrite5 k0 k1 k2 k3 k4 v m

alterF :: (Functor f, Ord k) => (Maybe (DeepMap ks v) -> f (Maybe (DeepMap ks v))) -> k -> DeepMap (k ': ks) v -> f (DeepMap (k ': ks) v)
alterF f k (Nest m) = Nest <$> Map.alterF f k m

alterF1 :: (Functor f, Ord k) => (Maybe v -> f (Maybe v)) -> k -> DeepMap '[k] v -> f (DeepMap '[k] v)
alterF1 f k m = alterF (fmap (fmap Bare) . f . fmap getBare) k m

alterF2 :: (Functor f, Ord k0, Ord k1) => (Maybe v -> f (Maybe v)) -> k0 -> k1 -> DeepMap '[k0, k1] v -> f (DeepMap '[k0, k1] v)
alterF2 f k0 k1 m =
    f (m @? k0 @??| k1) <&> \case
        Nothing -> delete2 k0 k1 m
        Just v -> overwrite2 k0 k1 v m

alterF3 :: (Functor f, Ord k0, Ord k1, Ord k2) => (Maybe v -> f (Maybe v)) -> k0 -> k1 -> k2 -> DeepMap '[k0, k1, k2] v -> f (DeepMap '[k0, k1, k2] v)
alterF3 f k0 k1 k2 m =
    f (m @? k0 @?? k1 @??| k2) <&> \case
        Nothing -> delete3 k0 k1 k2 m
        Just v -> overwrite3 k0 k1 k2 v m

alterF4 :: (Functor f, Ord k0, Ord k1, Ord k2, Ord k3) => (Maybe v -> f (Maybe v)) -> k0 -> k1 -> k2 -> k3 -> DeepMap '[k0, k1, k2, k3] v -> f (DeepMap '[k0, k1, k2, k3] v)
alterF4 f k0 k1 k2 k3 m =
    f (m @? k0 @?? k1 @?? k2 @??| k3) <&> \case
        Nothing -> delete4 k0 k1 k2 k3 m
        Just v -> overwrite4 k0 k1 k2 k3 v m

alterF5 :: (Functor f, Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => (Maybe v -> f (Maybe v)) -> k0 -> k1 -> k2 -> k3 -> k4 -> DeepMap '[k0, k1, k2, k3, k4] v -> f (DeepMap '[k0, k1, k2, k3, k4] v)
alterF5 f k0 k1 k2 k3 k4 m =
    f (m @? k0 @?? k1 @?? k2 @?? k3 @??| k4) <&> \case
        Nothing -> delete5 k0 k1 k2 k3 k4 m
        Just v -> overwrite5 k0 k1 k2 k3 k4 v m

-- | /O(log n)/. Lookup the value at a key.
lookup :: (Ord k) => k -> DeepMap (k ': ks) v -> Maybe (DeepMap ks v)
lookup k (Nest m) = Map.lookup k m

-- | /O(log n)/. Lookup the value at a key.
lookup1 :: (Ord k) => k -> DeepMap '[k] v -> Maybe v
lookup1 k (Nest m) = getBare <$> Map.lookup k m

-- | /O(log n)/. A flipped, infix variant of 'lookup'.
(@?) :: (Ord k) => DeepMap (k ': ks) v -> k -> Maybe (DeepMap ks v)
(@?) = flip lookup

-- | /O(log n)/. A flipped, infix variant of 'lookup1'.
(@?|) :: (Ord k) => DeepMap '[k] v -> k -> Maybe v
(@?|) = flip lookup1

-- | /O(log n)/. Facilitates chaining of lookups. For @m :: DeepMap '[k0, k1, k2] v@,
--
-- >>> m @? k0 @?? k1 @??| k2 == (m @? k0) >>= (@? k1) >>= (@?| k2)
(@??) :: (Ord k) => Maybe (DeepMap (k ': ks) v) -> k -> Maybe (DeepMap ks v)
mm @?? k = mm >>= (@? k)

-- | /O(log n)/. Facilitates chaining of lookups. For @m :: DeepMap '[k0, k1, k2] v@,
--
-- >>> m @? k0 @?? k1 @??| k2 == (m @? k0) >>= (@? k1) >>= (@?| k2)
(@??|) :: (Ord k) => Maybe (DeepMap '[k] v) -> k -> Maybe v
mm @??| k = mm >>= (@?| k)

-- | /O(log n)/. A version of '(@?)' that returns 'mempty' when the element cannot be found.
(@!) :: (Ord k, Monoid (DeepMap ks v)) => DeepMap (k ': ks) v -> k -> DeepMap ks v
(@!) = fromMaybe mempty .: (@?)

-- | /O(log n)/. A version of '(@?|)' that returns 'mempty' when the element cannot be found.
(@!|) :: (Ord k, Monoid v) => DeepMap '[k] v -> k -> v
(@!|) = fromMaybe mempty .: (@?|)

-- | /O(log n)/. Lookup the 'DeepMap' at a key, with a default if the key is missing.
findWithDefault :: (Ord k) => DeepMap ks v -> k -> DeepMap (k ': ks) v -> DeepMap ks v
findWithDefault a = fromMaybe a .: lookup

-- | /O(log n)/. Lookup the value at a key, with a default if the key is missing.
findWithDefault1 :: (Ord k) => v -> k -> DeepMap '[k] v -> v
findWithDefault1 a k m = fromMaybe a $ m @?| k

-- | /O(log n)/. Lookup the value at a key, with a default if the key is missing.
findWithDefault2 :: (Ord k0, Ord k1) => v -> k0 -> k1 -> DeepMap '[k0, k1] v -> v
findWithDefault2 a k0 k1 m = fromMaybe a $ m @? k0 @??| k1

-- | /O(log n)/. Lookup the value at a key, with a default if the key is missing.
findWithDefault3 :: (Ord k0, Ord k1, Ord k2) => v -> k0 -> k1 -> k2 -> DeepMap '[k0, k1, k2] v -> v
findWithDefault3 a k0 k1 k2 m = fromMaybe a $ m @? k0 @?? k1 @??| k2

-- | /O(log n)/. Lookup the value at a key, with a default if the key is missing.
findWithDefault4 :: (Ord k0, Ord k1, Ord k2, Ord k3) => v -> k0 -> k1 -> k2 -> k3 -> DeepMap '[k0, k1, k2, k3] v -> v
findWithDefault4 a k0 k1 k2 k3 m = fromMaybe a $ m @? k0 @?? k1 @?? k2 @??| k3

-- | /O(log n)/. Lookup the value at a key, with a default if the key is missing.
findWithDefault5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => v -> k0 -> k1 -> k2 -> k3 -> k4 -> DeepMap '[k0, k1, k2, k3, k4] v -> v
findWithDefault5 a k0 k1 k2 k3 k4 m = fromMaybe a $ m @? k0 @?? k1 @?? k2 @?? k3 @??| k4

-- | /O(log n)/. Is the key a member of the map? See also 'notMember'.
member :: (Ord k) => k -> DeepMap (k ': ks) v -> Bool
member k (Nest m) = Map.member k m

-- | /O(log n)/. Is the key missing from the map? See also 'member'.
notMember :: (Ord k) => k -> DeepMap (k ': ks) v -> Bool
notMember k (Nest m) = Map.notMember k m

-- | Find the next smallest key to the given one, and return its key/value pair.
lookupLT :: (Ord k) => k -> DeepMap (k ': ks) v -> Maybe (k, DeepMap ks v)
lookupLT k (Nest m) = Map.lookupLT k m

-- | Find the next largest key to the given one, and return its key/value pair.
lookupGT :: (Ord k) => k -> DeepMap (k ': ks) v -> Maybe (k, DeepMap ks v)
lookupGT k (Nest m) = Map.lookupGT k m

-- | Find the largest key up to the given one, and return its key/value pair.
lookupLE :: (Ord k) => k -> DeepMap (k ': ks) v -> Maybe (k, DeepMap ks v)
lookupLE k (Nest m) = Map.lookupLE k m

-- | Find the smallest key down to the given one, and return its key/value pair.
lookupGE :: (Ord k) => k -> DeepMap (k ': ks) v -> Maybe (k, DeepMap ks v)
lookupGE k (Nest m) = Map.lookupGE k m

-- | /O(1)/. Is the 'DeepMap' empty?
null :: DeepMap (k ': ks) v -> Bool
null (Nest m) = Map.null m

-- | /O(1)/. The number of outermost keys in the 'DeepMap'.
size :: DeepMap (k ': ks) v -> Int
size (Nest m) = Map.size m

-- | /O(m log(n \/ m + 1)), m <= n/. Join two 'DeepMap's together using '(<>)' to combine
--   the values of duplicate keys.
--
--   To retain 'Data.Map'\'s left-biased functionality, use @'unionWith' 'const'@.
union :: (Ord k, Semigroup (DeepMap ks v)) => DeepMap (k ': ks) v -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
union = (<>)

-- | /O(m log(n \/ m + 1)), m <= n/. Join two 'DeepMap's with a combining function.
unionWith :: (Ord k) => (DeepMap ks v -> DeepMap ks v -> DeepMap ks v) -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
unionWith f m n = onNest2 (Map.unionWith f) m n

-- | /O(m log(n \/ m + 1)), m <= n/. Join two 'DeepMap's with a combining function.
unionWith1 :: (Ord k) => (v -> v -> v) -> DeepMap '[k] v -> DeepMap '[k] v -> DeepMap '[k] v
unionWith1 f m n = onNest2 (Map.unionWith (onBare2 f)) m n

-- | /O(m log(n \/ m + 1)), m <= n/. Join two 'DeepMap's with a combining function.
unionWith2 :: (Ord k0, Ord k1) => (v -> v -> v) -> DeepMap '[k0, k1] v -> DeepMap '[k0, k1] v -> DeepMap '[k0, k1] v
unionWith2 f m n = unionWith (unionWith1 f) m n

-- | /O(m log(n \/ m + 1)), m <= n/. Join two 'DeepMap's with a combining function.
unionWith3 :: (Ord k0, Ord k1, Ord k2) => (v -> v -> v) -> DeepMap '[k0, k1, k2] v -> DeepMap '[k0, k1, k2] v -> DeepMap '[k0, k1, k2] v
unionWith3 f m n = unionWith (unionWith2 f) m n

-- | /O(m log(n \/ m + 1)), m <= n/. Join two 'DeepMap's with a combining function.
unionWith4 :: (Ord k0, Ord k1, Ord k2, Ord k3) => (v -> v -> v) -> DeepMap '[k0, k1, k2, k3] v -> DeepMap '[k0, k1, k2, k3] v -> DeepMap '[k0, k1, k2, k3] v
unionWith4 f m n = unionWith (unionWith3 f) m n

-- | /O(m log(n \/ m + 1)), m <= n/. Join two 'DeepMap's with a combining function.
unionWith5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => (v -> v -> v) -> DeepMap '[k0, k1, k2, k3, k4] v -> DeepMap '[k0, k1, k2, k3, k4] v -> DeepMap '[k0, k1, k2, k3, k4] v
unionWith5 f m n = unionWith (unionWith4 f) m n

-- | /O(m log(n \/ m + 1)), m <= n/. Join two maps with a combining function with access to the keys.
unionWithKey :: (Ord k) => (k -> DeepMap ks v -> DeepMap ks v -> DeepMap ks v) -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
unionWithKey f m n = onNest2 (Map.unionWithKey f) m n

-- | /O(m log(n \/ m + 1)), m <= n/. Join two 'DeepMap's with a combining function with access to the keys.
unionWithKey1 :: (Ord k) => (k -> v -> v -> v) -> DeepMap '[k] v -> DeepMap '[k] v -> DeepMap '[k] v
unionWithKey1 f m n = onNest2 (Map.unionWithKey $ onBare2 . f) m n

-- | /O(m log(n \/ m + 1)), m <= n/. Join two 'DeepMap's with a combining function with access to the keys.
unionWithKey2 :: (Ord k0, Ord k1) => (k0 -> k1 -> v -> v -> v) -> DeepMap '[k0, k1] v -> DeepMap '[k0, k1] v -> DeepMap '[k0, k1] v
unionWithKey2 f m n = unionWithKey (unionWithKey1 . f) m n

-- | /O(m log(n \/ m + 1)), m <= n/. Join two 'DeepMap's with a combining function with access to the keys.
unionWithKey3 :: (Ord k0, Ord k1, Ord k2) => (k0 -> k1 -> k2 -> v -> v -> v) -> DeepMap '[k0, k1, k2] v -> DeepMap '[k0, k1, k2] v -> DeepMap '[k0, k1, k2] v
unionWithKey3 f m n = unionWithKey (unionWithKey2 . f) m n

-- | /O(m log(n \/ m + 1)), m <= n/. Join two 'DeepMap's with a combining function with access to the keys.
unionWithKey4 :: (Ord k0, Ord k1, Ord k2, Ord k3) => (k0 -> k1 -> k2 -> k3 -> v -> v -> v) -> DeepMap '[k0, k1, k2, k3] v -> DeepMap '[k0, k1, k2, k3] v -> DeepMap '[k0, k1, k2, k3] v
unionWithKey4 f m n = unionWithKey (unionWithKey3 . f) m n

-- | /O(m log(n \/ m + 1)), m <= n/. Join two 'DeepMap's with a combining function with access to the keys.
unionWithKey5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => (k0 -> k1 -> k2 -> k3 -> k4 -> v -> v -> v) -> DeepMap '[k0, k1, k2, k3, k4] v -> DeepMap '[k0, k1, k2, k3, k4] v -> DeepMap '[k0, k1, k2, k3, k4] v
unionWithKey5 f m n = unionWithKey (unionWithKey4 . f) m n

-- | A synonym for 'fold'. To retain 'Data.Map'\'s functionality, use @'unionsWith' 'const'@.
unions :: (Foldable t, Ord k, Semigroup (DeepMap ks v)) => t (DeepMap (k ': ks) v) -> DeepMap (k ': ks) v
unions = fold

-- | The union of a list of 'DeepMap's, combining with a specified operation.
unionsWith :: (Foldable t, Ord k) => (DeepMap ks v -> DeepMap ks v -> DeepMap ks v) -> t (DeepMap (k ': ks) v) -> DeepMap (k ': ks) v
unionsWith f = foldl (unionWith f) empty

-- | The union of a list of 'DeepMap's, combining with a specified operation.
unionsWith1 :: (Foldable t, Ord k) => (v -> v -> v) -> t (DeepMap '[k] v) -> DeepMap '[k] v
unionsWith1 f = foldl (unionWith1 f) empty

-- | /O(m log(n \/ m + 1)), m <= n/. The set-difference of the keys in a 'DeepMap',
--   keeping the values of the left-hand map.
difference :: (Ord k) => DeepMap (k ': ks) v -> DeepMap (k ': ls) w -> DeepMap (k ': ks) v
difference m n = onNest2 Map.difference m n

-- | Infix synonym for 'difference'.
(\\) :: (Ord k) => DeepMap (k ': ks) v -> DeepMap (k ': ls) w -> DeepMap (k ': ks) v
(\\) = difference

-- | /O(n + m)/. Difference with a combining function. Deletes keys if the value is 'Nothing'.
differenceWith :: (Ord k) => (DeepMap ks v -> DeepMap ls w -> Maybe (DeepMap ks v)) -> DeepMap (k ': ks) v -> DeepMap (k ': ls) w -> DeepMap (k ': ks) v
differenceWith f m n = onNest2 (Map.differenceWith f) m n

-- | /O(n + m)/. Difference with a combining function. Deletes keys if the value is 'Nothing'.
differenceWith1 :: (Ord k) => (v -> w -> Maybe v) -> DeepMap '[k] v -> DeepMap '[k] w -> DeepMap '[k] v
differenceWith1 f m n = onNest2 (Map.differenceWith $ onBare2F f) m n

-- | /O(n + m)/. Difference with a combining function. Deletes keys if the value is 'Nothing'.
differenceWithKey :: (Ord k) => (k -> DeepMap ks v -> DeepMap ls w -> Maybe (DeepMap ks v)) -> DeepMap (k ': ks) v -> DeepMap (k ': ls) w -> DeepMap (k ': ks) v
differenceWithKey f m n = onNest2 (Map.differenceWithKey f) m n

-- | /O(n + m)/. Difference with a combining function. Deletes keys if the value is 'Nothing'.
differenceWithKey1 :: (Ord k) => (k -> v -> w -> Maybe v) -> DeepMap '[k] v -> DeepMap '[k] w -> DeepMap '[k] v
differenceWithKey1 f m n = onNest2 (Map.differenceWithKey $ onBare2F . f) m n

-- | /O(m log(n \/ m + 1)), m <= n/. The set-intersection of the keys in a map,
--   keeping the values of the left-hand map.
intersection :: (Ord k) => DeepMap (k ': ks) v -> DeepMap (k ': ls) w -> DeepMap (k ': ks) v
intersection m n = onNest2 Map.intersection m n

-- | /O(m log(n \/ m + 1)), m <= n/. Intersection with a combining function.
intersectionWith :: (Ord k) => (DeepMap ks v -> DeepMap ls w -> DeepMap ms x) -> DeepMap (k ': ks) v -> DeepMap (k ': ls) w -> DeepMap (k ': ms) x
intersectionWith f m n = onNest2 (Map.intersectionWith f) m n

-- | /O(m log(n \/ m + 1)), m <= n/. Intersection with a combining function.
intersectionWith1 :: (Ord k) => (v -> w -> x) -> DeepMap '[k] v -> DeepMap '[k] w -> DeepMap '[k] x
intersectionWith1 f m n = onNest2 (Map.intersectionWith $ onBare2 f) m n

-- | /O(m log(n \/ m + 1)), m <= n/. Intersection with a combining function.
intersectionWithKey :: (Ord k) => (k -> DeepMap ks v -> DeepMap ls w -> DeepMap ms x) -> DeepMap (k ': ks) v -> DeepMap (k ': ls) w -> DeepMap (k ': ms) x
intersectionWithKey f m n = onNest2 (Map.intersectionWithKey f) m n

-- | /O(m log(n \/ m + 1)), m <= n/. Intersection with a combining function.
intersectionWithKey1 :: (Ord k) => (k -> v -> w -> x) -> DeepMap '[k] v -> DeepMap '[k] w -> DeepMap '[k] x
intersectionWithKey1 f m n = onNest2 (Map.intersectionWithKey $ onBare2 . f) m n

-- | /O(m log(n \/ m + 1)), m <= n/. Intersection with a combining function.
intersectionWithKey2 :: (Ord k0, Ord k1) => (k0 -> k1 -> v -> w -> x) -> DeepMap '[k0, k1] v -> DeepMap '[k0, k1] w -> DeepMap '[k0, k1] x
intersectionWithKey2 f m n = intersectionWithKey (intersectionWithKey1 . f) m n

-- | /O(m log(n \/ m + 1)), m <= n/. Intersection with a combining function.
intersectionWithKey3 :: (Ord k0, Ord k1, Ord k2) => (k0 -> k1 -> k2 -> v -> w -> x) -> DeepMap '[k0, k1, k2] v -> DeepMap '[k0, k1, k2] w -> DeepMap '[k0, k1, k2] x
intersectionWithKey3 f m n = intersectionWithKey (intersectionWithKey2 . f) m n

-- | /O(m log(n \/ m + 1)), m <= n/. Intersection with a combining function.
intersectionWithKey4 :: (Ord k0, Ord k1, Ord k2, Ord k3) => (k0 -> k1 -> k2 -> k3 -> v -> w -> x) -> DeepMap '[k0, k1, k2, k3] v -> DeepMap '[k0, k1, k2, k3] w -> DeepMap '[k0, k1, k2, k3] x
intersectionWithKey4 f m n = intersectionWithKey (intersectionWithKey3 . f) m n

-- | /O(m log(n \/ m + 1)), m <= n/. Intersection with a combining function.
intersectionWithKey5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => (k0 -> k1 -> k2 -> k3 -> k4 -> v -> w -> x) -> DeepMap '[k0, k1, k2, k3, k4] v -> DeepMap '[k0, k1, k2, k3, k4] w -> DeepMap '[k0, k1, k2, k3, k4] x
intersectionWithKey5 f m n = intersectionWithKey (intersectionWithKey4 . f) m n

-- | /O(n)/. Strictly more general than 'fmap' in that it may change the types of the inner keys.
mapDeep :: (DeepMap ks v -> DeepMap ls w) -> DeepMap (k ': ks) v -> DeepMap (k ': ls) w
mapDeep f (Nest m) = Nest $ fmap f m

-- | /O(n)/. Like 'mapDeep' but the function has access to the outer keys.
mapDeepWithKey :: (k -> DeepMap ks v -> DeepMap ls w) -> DeepMap (k ': ks) v -> DeepMap (k ': ls) w
mapDeepWithKey f (Nest m) = Nest $ Map.mapWithKey f m

-- | /O(n)/. Like 'fmap' but the function has access to the outer keys.
mapWithKey1 :: (k -> v -> w) -> DeepMap '[k] v -> DeepMap '[k] w
mapWithKey1 f (Nest m) = Nest $ Map.mapWithKey (fmap . f) m

-- | /O(n)/. Like 'fmap' but the function has access to the outer keys.
mapWithKey2 :: (k0 -> k1 -> v -> w) -> DeepMap '[k0, k1] v -> DeepMap '[k0, k1] w
mapWithKey2 f m = mapDeepWithKey (mapWithKey1 . f) m

-- | /O(n)/. Like 'fmap' but the function has access to the outer keys.
mapWithKey3 :: (k0 -> k1 -> k2 -> v -> w) -> DeepMap '[k0, k1, k2] v -> DeepMap '[k0, k1, k2] w
mapWithKey3 f m = mapDeepWithKey (mapWithKey2 . f) m

-- | /O(n)/. Like 'fmap' but the function has access to the outer keys.
mapWithKey4 :: (k0 -> k1 -> k2 -> k3 -> v -> w) -> DeepMap '[k0, k1, k2, k3] v -> DeepMap '[k0, k1, k2, k3] w
mapWithKey4 f m = mapDeepWithKey (mapWithKey3 . f) m

-- | /O(n)/. Like 'fmap' but the function has access to the outer keys.
mapWithKey5 :: (k0 -> k1 -> k2 -> k3 -> k4 -> v -> w) -> DeepMap '[k0, k1, k2, k3, k4] v -> DeepMap '[k0, k1, k2, k3, k4] w
mapWithKey5 f m = mapDeepWithKey (mapWithKey4 . f) m

-- | /O(n)/. Strictly more general than 'traverse' in that it may change the types of the inner keys.
traverseDeep :: (Applicative f) => (DeepMap ks v -> f (DeepMap ls w)) -> DeepMap (k ': ks) v -> f (DeepMap (k ': ls) w)
traverseDeep f (Nest m) = Nest <$> traverse f m

-- | /O(n)/. Like 'traverseDeep' but the function has access to the keys.
traverseDeepWithKey :: (Applicative f) => (k -> DeepMap ks v -> f (DeepMap ls w)) -> DeepMap (k ': ks) v -> f (DeepMap (k ': ls) w)
traverseDeepWithKey f (Nest m) = Nest <$> Map.traverseWithKey f m

-- | /O(n)/. Like 'traverse' but the function has access to the keys.
traverseWithKey1 :: (Applicative f) => (k -> v -> f w) -> DeepMap '[k] v -> f (DeepMap '[k] w)
traverseWithKey1 f (Nest m) = Nest <$> Map.traverseWithKey (traverse . f) m

-- | /O(n)/. Like 'traverse' but the function has access to the keys.
traverseWithKey2 :: (Applicative f) => (k0 -> k1 -> v -> f w) -> DeepMap '[k0, k1] v -> f (DeepMap '[k0, k1] w)
traverseWithKey2 f m = traverseDeepWithKey (traverseWithKey1 . f) m

-- | /O(n)/. Like 'traverse' but the function has access to the keys.
traverseWithKey3 :: (Applicative f) => (k0 -> k1 -> k2 -> v -> f w) -> DeepMap '[k0, k1, k2] v -> f (DeepMap '[k0, k1, k2] w)
traverseWithKey3 f m = traverseDeepWithKey (traverseWithKey2 . f) m

-- | /O(n)/. Like 'traverse' but the function has access to the keys.
traverseWithKey4 :: (Applicative f) => (k0 -> k1 -> k2 -> k3 -> v -> f w) -> DeepMap '[k0, k1, k2, k3] v -> f (DeepMap '[k0, k1, k2, k3] w)
traverseWithKey4 f m = traverseDeepWithKey (traverseWithKey3 . f) m

-- | /O(n)/. Like 'traverse' but the function has access to the keys.
traverseWithKey5 :: (Applicative f) => (k0 -> k1 -> k2 -> k3 -> k4 -> v -> f w) -> DeepMap '[k0, k1, k2, k3, k4] v -> f (DeepMap '[k0, k1, k2, k3, k4] w)
traverseWithKey5 f m = traverseDeepWithKey (traverseWithKey4 . f) m

-- | /O(n)/. Traverse keys/submaps and collect the 'Just' results.
traverseMaybeWithKey :: (Applicative f) => (k -> DeepMap ks v -> f (Maybe (DeepMap ls w))) -> DeepMap (k ': ks) v -> f (DeepMap (k ': ls) w)
traverseMaybeWithKey f (Nest m) = Nest <$> Map.traverseMaybeWithKey f m

-- | /O(n)/. Traverse keys/values and collect the 'Just' results.
traverseMaybeWithKey1 :: (Applicative f) => (k -> v -> f (Maybe w)) -> DeepMap '[k] v -> f (DeepMap '[k] w)
traverseMaybeWithKey1 f (Nest m) = Nest <$> Map.traverseMaybeWithKey (\k (Bare v) -> fmap Bare <$> f k v) m

-- | /O(n)/. Traverse keys/values and collect the 'Just' results.
traverseMaybeWithKey2 :: (Applicative f) => (k0 -> k1 -> v -> f (Maybe w)) -> DeepMap '[k0, k1] v -> f (DeepMap '[k0, k1] w)
traverseMaybeWithKey2 f m = traverseMaybeWithKey (fmap (fmap Just) . traverseMaybeWithKey1 . f) m

-- | /O(n)/. Traverse keys/values and collect the 'Just' results.
traverseMaybeWithKey3 :: (Applicative f) => (k0 -> k1 -> k2 -> v -> f (Maybe w)) -> DeepMap '[k0, k1, k2] v -> f (DeepMap '[k0, k1, k2] w)
traverseMaybeWithKey3 f m = traverseMaybeWithKey (fmap (fmap Just) . traverseMaybeWithKey2 . f) m

-- | /O(n)/. Traverse keys/values and collect the 'Just' results.
traverseMaybeWithKey4 :: (Applicative f) => (k0 -> k1 -> k2 -> k3 -> v -> f (Maybe w)) -> DeepMap '[k0, k1, k2, k3] v -> f (DeepMap '[k0, k1, k2, k3] w)
traverseMaybeWithKey4 f m = traverseMaybeWithKey (fmap (fmap Just) . traverseMaybeWithKey3 . f) m

-- | /O(n)/. Traverse keys/values and collect the 'Just' results.
traverseMaybeWithKey5 :: (Applicative f) => (k0 -> k1 -> k2 -> k3 -> k4 -> v -> f (Maybe w)) -> DeepMap '[k0, k1, k2, k3, k4] v -> f (DeepMap '[k0, k1, k2, k3, k4] w)
traverseMaybeWithKey5 f m = traverseMaybeWithKey (fmap (fmap Just) . traverseMaybeWithKey4 . f) m

-- | /O(n)/. Thread an accumulating argument through the 'DeepMap' in ascending order of keys.
mapAccum :: (acc -> DeepMap ks v -> (acc, DeepMap ls w)) -> acc -> DeepMap (k ': ks) v -> (acc, DeepMap (k ': ls) w)
mapAccum f acc (Nest m) = Nest <$> Map.mapAccum f acc m

-- | /O(n)/. Thread an accumulating argument through the 'DeepMap' in ascending order of keys.
mapAccum1 :: (acc -> v -> (acc, w)) -> acc -> DeepMap '[k] v -> (acc, DeepMap '[k] w)
mapAccum1 f acc m = mapAccum (\a (Bare v) -> Bare <$> f a v) acc m

-- | /O(n)/. Thread an accumulating argument through the 'DeepMap' in descending order of keys.
mapAccumR :: (acc -> DeepMap ks v -> (acc, DeepMap ls w)) -> acc -> DeepMap (k ': ks) v -> (acc, DeepMap (k ': ls) w)
mapAccumR f acc (Nest m) = Nest <$> Map.mapAccumR f acc m

-- | /O(n)/. Thread an accumulating argument through the 'DeepMap' in descending order of keys.
mapAccumR1 :: (acc -> v -> (acc, w)) -> acc -> DeepMap '[k] v -> (acc, DeepMap '[k] w)
mapAccumR1 f acc m = mapAccumR (\a (Bare v) -> Bare <$> f a v) acc m

-- | /O(n)/. Like 'mapAccum' but the function has access to the keys.
mapAccumWithKey :: (acc -> k -> DeepMap ks v -> (acc, DeepMap ls w)) -> acc -> DeepMap (k ': ks) v -> (acc, DeepMap (k ': ls) w)
mapAccumWithKey f acc (Nest m) = Nest <$> Map.mapAccumWithKey f acc m

-- | /O(n)/. Like 'mapAccum' but the function has access to the keys.
mapAccumWithKey1 :: (acc -> k -> v -> (acc, w)) -> acc -> DeepMap '[k] v -> (acc, DeepMap '[k] w)
mapAccumWithKey1 f acc m = mapAccumWithKey (\k a (Bare v) -> Bare <$> f k a v) acc m

-- | /O(n)/. Like 'mapAccum' but the function has access to the keys.
mapAccumWithKey2 :: (acc -> k0 -> k1 -> v -> (acc, w)) -> acc -> DeepMap '[k0, k1] v -> (acc, DeepMap '[k0, k1] w)
mapAccumWithKey2 f acc m = mapAccumWithKey (\a k0 -> mapAccumWithKey1 (`f` k0) a) acc m

-- | /O(n)/. Like 'mapAccum' but the function has access to the keys.
mapAccumWithKey3 :: (acc -> k0 -> k1 -> k2 -> v -> (acc, w)) -> acc -> DeepMap '[k0, k1, k2] v -> (acc, DeepMap '[k0, k1, k2] w)
mapAccumWithKey3 f acc m = mapAccumWithKey (\a k0 -> mapAccumWithKey2 (`f` k0) a) acc m

-- | /O(n)/. Like 'mapAccum' but the function has access to the keys.
mapAccumWithKey4 :: (acc -> k0 -> k1 -> k2 -> k3 -> v -> (acc, w)) -> acc -> DeepMap '[k0, k1, k2, k3] v -> (acc, DeepMap '[k0, k1, k2, k3] w)
mapAccumWithKey4 f acc m = mapAccumWithKey (\a k0 -> mapAccumWithKey3 (`f` k0) a) acc m

-- | /O(n)/. Like 'mapAccum' but the function has access to the keys.
mapAccumWithKey5 :: (acc -> k0 -> k1 -> k2 -> k3 -> k4 -> v -> (acc, w)) -> acc -> DeepMap '[k0, k1, k2, k3, k4] v -> (acc, DeepMap '[k0, k1, k2, k3, k4] w)
mapAccumWithKey5 f acc m = mapAccumWithKey (\a k0 -> mapAccumWithKey4 (`f` k0) a) acc m

-- | /O(n)/. Like 'mapAccumR' but the function has access to the keys.
mapAccumRWithKey :: (acc -> k -> DeepMap ks v -> (acc, DeepMap ls w)) -> acc -> DeepMap (k ': ks) v -> (acc, DeepMap (k ': ls) w)
mapAccumRWithKey f acc (Nest m) = Nest <$> Map.mapAccumRWithKey f acc m

-- | /O(n)/. Like 'mapAccumR' but the function has access to the keys.
mapAccumRWithKey1 :: (acc -> k -> v -> (acc, w)) -> acc -> DeepMap '[k] v -> (acc, DeepMap '[k] w)
mapAccumRWithKey1 f acc m = mapAccumRWithKey (\k a (Bare v) -> Bare <$> f k a v) acc m

-- | /O(n)/. Like 'mapAccumR' but the function has access to the keys.
mapAccumRWithKey2 :: (acc -> k0 -> k1 -> v -> (acc, w)) -> acc -> DeepMap '[k0, k1] v -> (acc, DeepMap '[k0, k1] w)
mapAccumRWithKey2 f acc m = mapAccumRWithKey (\a k0 -> mapAccumRWithKey1 (`f` k0) a) acc m

-- | /O(n)/. Like 'mapAccumR' but the function has access to the keys.
mapAccumRWithKey3 :: (acc -> k0 -> k1 -> k2 -> v -> (acc, w)) -> acc -> DeepMap '[k0, k1, k2] v -> (acc, DeepMap '[k0, k1, k2] w)
mapAccumRWithKey3 f acc m = mapAccumRWithKey (\a k0 -> mapAccumRWithKey2 (`f` k0) a) acc m

-- | /O(n)/. Like 'mapAccumR' but the function has access to the keys.
mapAccumRWithKey4 :: (acc -> k0 -> k1 -> k2 -> k3 -> v -> (acc, w)) -> acc -> DeepMap '[k0, k1, k2, k3] v -> (acc, DeepMap '[k0, k1, k2, k3] w)
mapAccumRWithKey4 f acc m = mapAccumRWithKey (\a k0 -> mapAccumRWithKey3 (`f` k0) a) acc m

-- | /O(n)/. Like 'mapAccumR' but the function has access to the keys.
mapAccumRWithKey5 :: (acc -> k0 -> k1 -> k2 -> k3 -> k4 -> v -> (acc, w)) -> acc -> DeepMap '[k0, k1, k2, k3, k4] v -> (acc, DeepMap '[k0, k1, k2, k3, k4] w)
mapAccumRWithKey5 f acc m = mapAccumRWithKey (\a k0 -> mapAccumRWithKey4 (`f` k0) a) acc m

-- | /O(n log n)/. Map a function over the outer keys of a 'DeepMap'.
--   If the function maps two or more @j@-keys to the same @k@-key,
--   the values of the @j@-keys are combined with '(<>)'.
--
--   To retain 'Data.Map'\'s greatest-biased functionality, use @'mapKeysWith' 'const'@.
mapKeys :: (Ord k, Semigroup (DeepMap ks v)) => (j -> k) -> DeepMap (j ': ks) v -> DeepMap (k ': ks) v
mapKeys f (Nest m) = Nest $ Map.mapKeysWith (<>) f m

-- | /O(n log n)/. Map a function over the keys of a 'DeepMap'.
mapKeys1 :: (Ord k, Semigroup v) => (j -> k) -> DeepMap '[j] v -> DeepMap '[k] v
mapKeys1 f m = mapKeys f m

-- | /O(n log n)/. Map a function over the keys of a 'DeepMap'.
mapKeys2 :: (Ord k0, Ord k1, Semigroup (DeepMap ks v)) => (j0 -> k0) -> (j1 -> k1) -> DeepMap (j0 ': j1 ': ks) v -> DeepMap (k0 ': k1 ': ks) v
mapKeys2 f0 f1 m = mapKeys f0 $ mapDeep (mapKeys f1) m

-- | /O(n log n)/. Map a function over the keys of a 'DeepMap'.
mapKeys3 :: (Ord k0, Ord k1, Ord k2, Semigroup (DeepMap ks v)) => (j0 -> k0) -> (j1 -> k1) -> (j2 -> k2) -> DeepMap (j0 ': j1 ': j2 ': ks) v -> DeepMap (k0 ': k1 ': k2 ': ks) v
mapKeys3 f0 f1 f2 m = mapKeys f0 $ mapDeep (mapKeys2 f1 f2) m

-- | /O(n log n)/. Map a function over the keys of a 'DeepMap'.
mapKeys4 :: (Ord k0, Ord k1, Ord k2, Ord k3, Semigroup (DeepMap ks v)) => (j0 -> k0) -> (j1 -> k1) -> (j2 -> k2) -> (j3 -> k3) -> DeepMap (j0 ': j1 ': j2 ': j3 ': ks) v -> DeepMap (k0 ': k1 ': k2 ': k3 ': ks) v
mapKeys4 f0 f1 f2 f3 m = mapKeys f0 $ mapDeep (mapKeys3 f1 f2 f3) m

-- | /O(n log n)/. Map a function over the keys of a 'DeepMap'.
mapKeys5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4, Semigroup (DeepMap ks v)) => (j0 -> k0) -> (j1 -> k1) -> (j2 -> k2) -> (j3 -> k3) -> (j4 -> k4) -> DeepMap (j0 ': j1 ': j2 ': j3 ': j4 ': ks) v -> DeepMap (k0 ': k1 ': k2 ': k3 ': k4 ': ks) v
mapKeys5 f0 f1 f2 f3 f4 m = mapKeys f0 $ mapDeep (mapKeys4 f1 f2 f3 f4) m

-- | /O(n log n)/. Map a function over the outer keys of a 'DeepMap' with a combining function.
mapKeysWith :: (Ord k) => (DeepMap ks v -> DeepMap ks v -> DeepMap ks v) -> (j -> k) -> DeepMap (j ': ks) v -> DeepMap (k ': ks) v
mapKeysWith (~~) f (Nest m) = Nest $ Map.mapKeysWith (~~) f m

-- | /O(n log n)/. Map a function over the keys of a 'DeepMap' with a value-combining function.
mapKeysWith1 :: (Ord k) => (v -> v -> v) -> (j -> k) -> DeepMap '[j] v -> DeepMap '[k] v
mapKeysWith1 (~~) f m = mapKeysWith (onBare2 (~~)) f m

-- | /O(n log n)/. Map a function over the keys of a 'DeepMap' with a value-combining function.
mapKeysWith2 :: (Ord k0, Ord k1) => (v -> v -> v) -> (j0 -> k0) -> (j1 -> k1) -> DeepMap '[j0, j1] v -> DeepMap '[k0, k1] v
mapKeysWith2 (~~) f0 f1 m = mapKeysWith (unionWith1 (~~)) f0 $ mapDeep (mapKeysWith1 (~~) f1) m

-- | /O(n log n)/. Map a function over the keys of a 'DeepMap' with a value-combining function.
mapKeysWith3 :: (Ord k0, Ord k1, Ord k2) => (v -> v -> v) -> (j0 -> k0) -> (j1 -> k1) -> (j2 -> k2) -> DeepMap '[j0, j1, j2] v -> DeepMap '[k0, k1, k2] v
mapKeysWith3 (~~) f0 f1 f2 m = mapKeysWith (unionWith2 (~~)) f0 $ mapDeep (mapKeysWith2 (~~) f1 f2) m

-- | /O(n log n)/. Map a function over the keys of a 'DeepMap' with a value-combining function.
mapKeysWith4 :: (Ord k0, Ord k1, Ord k2, Ord k3) => (v -> v -> v) -> (j0 -> k0) -> (j1 -> k1) -> (j2 -> k2) -> (j3 -> k3) -> DeepMap '[j0, j1, j2, j3] v -> DeepMap '[k0, k1, k2, k3] v
mapKeysWith4 (~~) f0 f1 f2 f3 m = mapKeysWith (unionWith3 (~~)) f0 $ mapDeep (mapKeysWith3 (~~) f1 f2 f3) m

-- | /O(n log n)/. Map a function over the keys of a 'DeepMap' with a value-combining function.
mapKeysWith5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => (v -> v -> v) -> (j0 -> k0) -> (j1 -> k1) -> (j2 -> k2) -> (j3 -> k3) -> (j4 -> k4) -> DeepMap '[j0, j1, j2, j3, j4] v -> DeepMap '[k0, k1, k2, k3, k4] v
mapKeysWith5 (~~) f0 f1 f2 f3 f4 m = mapKeysWith (unionWith4 (~~)) f0 $ mapDeep (mapKeysWith4 (~~) f1 f2 f3 f4) m

-- | /O(n log n)/. Map an applicative function over the outer keys and collect the results.
traverseKeys :: (Applicative f, Ord k, Semigroup (DeepMap ks v)) => (j -> f k) -> DeepMap (j ': ks) v -> f (DeepMap (k ': ks) v)
traverseKeys f (Nest m) = Nest <$> Map.traverseKeys f m

-- | /O(n log n)/. Map an applicative function over the outer keys of the map
--   and collect the results using the specified combining function.
traverseKeysWith :: (Applicative f, Ord k) => (DeepMap ks v -> DeepMap ks v -> DeepMap ks v) -> (j -> f k) -> DeepMap (j ': ks) v -> f (DeepMap (k ': ks) v)
traverseKeysWith (~~) f (Nest m) = Nest <$> Map.traverseKeysWith (~~) f m

-- | /O(n log n)/. Map a monadic function over the keys of a 'DeepMap' and collect the results.
mapKeysM :: (Monad m, Ord k, Semigroup (DeepMap ks v)) => (j -> m k) -> DeepMap (j ': ks) v -> m (DeepMap (k ': ks) v)
mapKeysM f m = traverseKeys f m

-- | /O(n log n)/. Map a monadic function over the keys of a 'DeepMap' and collect the results.
mapKeysM1 :: (Monad m, Ord k, Semigroup (DeepMap ks v)) => (j -> m k) -> DeepMap (j ': ks) v -> m (DeepMap (k ': ks) v)
mapKeysM1 f m = mapKeysM f m

-- | /O(n log n)/. Map a monadic function over the keys of a 'DeepMap' and collect the results.
--
-- Sadly @traverseKeys2@ can't have this type signature because we'd end up with a twice-wrapped 'Applicative' and no way out.
mapKeysM2 :: (Monad m, Ord k0, Ord k1, Semigroup (DeepMap ks v)) => (j0 -> m k0) -> (j1 -> m k1) -> DeepMap (j0 ': j1 ': ks) v -> m (DeepMap (k0 ': k1 ': ks) v)
mapKeysM2 f0 f1 m = mapKeysM f0 =<< traverseDeep (mapKeysM1 f1) m

-- | /O(n log n)/. Map a monadic function over the keys of a 'DeepMap' and collect the results.
mapKeysM3 :: (Monad m, Ord k0, Ord k1, Ord k2, Semigroup (DeepMap ks v)) => (j0 -> m k0) -> (j1 -> m k1) -> (j2 -> m k2) -> DeepMap (j0 ': j1 ': j2 ': ks) v -> m (DeepMap (k0 ': k1 ': k2 ': ks) v)
mapKeysM3 f0 f1 f2 m = mapKeysM f0 =<< traverseDeep (mapKeysM2 f1 f2) m

-- | /O(n log n)/. Map a monadic function over the keys of a 'DeepMap' and collect the results.
mapKeysM4 :: (Monad m, Ord k0, Ord k1, Ord k2, Ord k3, Semigroup (DeepMap ks v)) => (j0 -> m k0) -> (j1 -> m k1) -> (j2 -> m k2) -> (j3 -> m k3) -> DeepMap (j0 ': j1 ': j2 ': j3 ': ks) v -> m (DeepMap (k0 ': k1 ': k2 ': k3 ': ks) v)
mapKeysM4 f0 f1 f2 f3 m = mapKeysM f0 =<< traverseDeep (mapKeysM3 f1 f2 f3) m

-- | /O(n log n)/. Map a monadic function over the keys of a 'DeepMap' and collect the results.
mapKeysM5 :: (Monad m, Ord k0, Ord k1, Ord k2, Ord k3, Ord k4, Semigroup (DeepMap ks v)) => (j0 -> m k0) -> (j1 -> m k1) -> (j2 -> m k2) -> (j3 -> m k3) -> (j4 -> m k4) -> DeepMap (j0 ': j1 ': j2 ': j3 ': j4 ': ks) v -> m (DeepMap (k0 ': k1 ': k2 ': k3 ': k4 ': ks) v)
mapKeysM5 f0 f1 f2 f3 f4 m = mapKeysM f0 =<< traverseDeep (mapKeysM4 f1 f2 f3 f4) m

-- | /O(n log n)/. Map a monadic function over the outer keys of a 'DeepMap' with a submap-combining function.
mapKeysMWith :: (Monad m, Ord k) => (DeepMap ks v -> DeepMap ks v -> DeepMap ks v) -> (j -> m k) -> DeepMap (j ': ks) v -> m (DeepMap (k ': ks) v)
mapKeysMWith f m = traverseKeysWith f m

-- | /O(n log n)/. Map a monadic function over the keys of a 'DeepMap' with a value-combining function.
mapKeysMWith1 :: (Monad m, Ord k) => (v -> v -> v) -> (j -> m k) -> DeepMap '[j] v -> m (DeepMap '[k] v)
mapKeysMWith1 (~~) f m = mapKeysMWith (onBare2 (~~)) f m

-- | /O(n log n)/. Map a monadic function over the keys of a 'DeepMap' with a value-combining function.
mapKeysMWith2 :: (Monad m, Ord k0, Ord k1) => (v -> v -> v) -> (j0 -> m k0) -> (j1 -> m k1) -> DeepMap '[j0, j1] v -> m (DeepMap '[k0, k1] v)
mapKeysMWith2 (~~) f0 f1 m = mapKeysMWith (unionWith1 (~~)) f0 =<< traverseDeep (mapKeysMWith1 (~~) f1) m

-- | /O(n log n)/. Map a monadic function over the keys of a 'DeepMap' with a value-combining function.
mapKeysMWith3 :: (Monad m, Ord k0, Ord k1, Ord k2) => (v -> v -> v) -> (j0 -> m k0) -> (j1 -> m k1) -> (j2 -> m k2) -> DeepMap '[j0, j1, j2] v -> m (DeepMap '[k0, k1, k2] v)
mapKeysMWith3 (~~) f0 f1 f2 m = mapKeysMWith (unionWith2 (~~)) f0 =<< traverseDeep (mapKeysMWith2 (~~) f1 f2) m

-- | /O(n log n)/. Map a monadic function over the keys of a 'DeepMap' with a value-combining function.
mapKeysMWith4 :: (Monad m, Ord k0, Ord k1, Ord k2, Ord k3) => (v -> v -> v) -> (j0 -> m k0) -> (j1 -> m k1) -> (j2 -> m k2) -> (j3 -> m k3) -> DeepMap '[j0, j1, j2, j3] v -> m (DeepMap '[k0, k1, k2, k3] v)
mapKeysMWith4 (~~) f0 f1 f2 f3 m = mapKeysMWith (unionWith3 (~~)) f0 =<< traverseDeep (mapKeysMWith3 (~~) f1 f2 f3) m

-- | /O(n log n)/. Map a monadic function over the keys of a 'DeepMap' with a value-combining function.
mapKeysMWith5 :: (Monad m, Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => (v -> v -> v) -> (j0 -> m k0) -> (j1 -> m k1) -> (j2 -> m k2) -> (j3 -> m k3) -> (j4 -> m k4) -> DeepMap '[j0, j1, j2, j3, j4] v -> m (DeepMap '[k0, k1, k2, k3, k4] v)
mapKeysMWith5 (~~) f0 f1 f2 f3 f4 m = mapKeysMWith (unionWith4 (~~)) f0 =<< traverseDeep (mapKeysMWith4 (~~) f1 f2 f3 f4) m

foldNest :: (Monoid (DeepMap ks v)) => DeepMap (k ': ks) v -> DeepMap ks v
foldNest (Nest m) = fold m

-- | /O(n)/. Fold the keys and submaps in the 'DeepMap' using the given right-associative binary operator.
foldrWithKey :: (k -> DeepMap ks v -> b -> b) -> b -> DeepMap (k ': ks) v -> b
foldrWithKey f z (Nest m) = Map.foldrWithKey f z m

-- | /O(n)/. Fold the keys and values using the given right-associative binary operator.
foldrWithKey1 :: (k -> v -> b -> b) -> b -> DeepMap '[k] v -> b
foldrWithKey1 f z m = foldrWithKey (\k (Bare v) -> f k v) z m

-- | /O(n)/. Fold the keys and values using the given right-associative binary operator.
foldrWithKey2 :: (k0 -> k1 -> v -> b -> b) -> b -> DeepMap '[k0, k1] v -> b
foldrWithKey2 f z m = foldrWithKey (\k0 dm b -> foldrWithKey1 (f k0) b dm) z m

-- | /O(n)/. Fold the keys and values using the given right-associative binary operator.
foldrWithKey3 :: (k0 -> k1 -> k2 -> v -> b -> b) -> b -> DeepMap '[k0, k1, k2] v -> b
foldrWithKey3 f z m = foldrWithKey (\k0 dm b -> foldrWithKey2 (f k0) b dm) z m

-- | /O(n)/. Fold the keys and values using the given right-associative binary operator.
foldrWithKey4 :: (k0 -> k1 -> k2 -> k3 -> v -> b -> b) -> b -> DeepMap '[k0, k1, k2, k3] v -> b
foldrWithKey4 f z m = foldrWithKey (\k0 dm b -> foldrWithKey3 (f k0) b dm) z m

-- | /O(n)/. Fold the keys and values using the given right-associative binary operator.
foldrWithKey5 :: (k0 -> k1 -> k2 -> k3 -> k3 -> v -> b -> b) -> b -> DeepMap '[k0, k1, k2, k3, k3] v -> b
foldrWithKey5 f z m = foldrWithKey (\k0 dm b -> foldrWithKey4 (f k0) b dm) z m

-- | /O(n)/. Fold the keys and submaps in the 'DeepMap' using the given left-associative binary operator.
foldlWithKey :: (b -> k -> DeepMap ks v -> b) -> b -> DeepMap (k ': ks) v -> b
foldlWithKey f z (Nest m) = Map.foldlWithKey f z m

-- | /O(n)/. Fold the keys and values in the 'DeepMap' using the given left-associative binary operator.
foldlWithKey1 :: (b -> k -> v -> b) -> b -> DeepMap '[k] v -> b
foldlWithKey1 f z m = foldlWithKey (\b k (Bare v) -> f b k v) z m

-- | /O(n)/. Fold the keys and values in the 'DeepMap' using the given left-associative binary operator.
foldlWithKey2 :: (b -> k0 -> k1 -> v -> b) -> b -> DeepMap '[k0, k1] v -> b
foldlWithKey2 f z m = foldlWithKey (\b k0 -> foldlWithKey1 (`f` k0) b) z m

-- | /O(n)/. Fold the keys and values in the 'DeepMap' using the given left-associative binary operator.
foldlWithKey3 :: (b -> k0 -> k1 -> k2 -> v -> b) -> b -> DeepMap '[k0, k1, k2] v -> b
foldlWithKey3 f z m = foldlWithKey (\b k0 -> foldlWithKey2 (`f` k0) b) z m

-- | /O(n)/. Fold the keys and values in the 'DeepMap' using the given left-associative binary operator.
foldlWithKey4 :: (b -> k0 -> k1 -> k2 -> k3 -> v -> b) -> b -> DeepMap '[k0, k1, k2, k3] v -> b
foldlWithKey4 f z m = foldlWithKey (\b k0 -> foldlWithKey3 (`f` k0) b) z m

-- | /O(n)/. Strictly fold the keys and values in the 'DeepMap' using the given left-associative binary operator.
foldlWithKey5 :: (b -> k0 -> k1 -> k2 -> k3 -> k4 -> v -> b) -> b -> DeepMap '[k0, k1, k2, k3, k4] v -> b
foldlWithKey5 f z m = foldlWithKey (\b k0 -> foldlWithKey4 (`f` k0) b) z m

-- | /O(n)/. Strictly fold the keys and submaps in the 'DeepMap' using the given right-associative binary operator.
foldrWithKey' :: (k -> DeepMap ks v -> b -> b) -> b -> DeepMap (k ': ks) v -> b
foldrWithKey' f z (Nest m) = Map.foldrWithKey' f z m

-- | /O(n)/. Strictly fold the keys and values using the given right-associative binary operator.
foldrWithKey1' :: (k -> v -> b -> b) -> b -> DeepMap '[k] v -> b
foldrWithKey1' f z m = foldrWithKey' (\k (Bare v) -> f k v) z m

-- | /O(n)/. Strictly fold the keys and values using the given right-associative binary operator.
foldrWithKey2' :: (k0 -> k1 -> v -> b -> b) -> b -> DeepMap '[k0, k1] v -> b
foldrWithKey2' f z m = foldrWithKey' (\k0 dm b -> foldrWithKey1' (f k0) b dm) z m

-- | /O(n)/. Strictly fold the keys and values using the given right-associative binary operator.
foldrWithKey3' :: (k0 -> k1 -> k2 -> v -> b -> b) -> b -> DeepMap '[k0, k1, k2] v -> b
foldrWithKey3' f z m = foldrWithKey' (\k0 dm b -> foldrWithKey2' (f k0) b dm) z m

-- | /O(n)/. Strictly fold the keys and values using the given right-associative binary operator.
foldrWithKey4' :: (k0 -> k1 -> k2 -> k3 -> v -> b -> b) -> b -> DeepMap '[k0, k1, k2, k3] v -> b
foldrWithKey4' f z m = foldrWithKey' (\k0 dm b -> foldrWithKey3' (f k0) b dm) z m

-- | /O(n)/. Strictly fold the keys and values using the given right-associative binary operator.
foldrWithKey5' :: (k0 -> k1 -> k2 -> k3 -> k3 -> v -> b -> b) -> b -> DeepMap '[k0, k1, k2, k3, k3] v -> b
foldrWithKey5' f z m = foldrWithKey' (\k0 dm b -> foldrWithKey4' (f k0) b dm) z m

-- | /O(n)/. Strictly fold the keys and submaps in the 'DeepMap' using the given left-associative binary operator.
foldlWithKey' :: (b -> k -> DeepMap ks v -> b) -> b -> DeepMap (k ': ks) v -> b
foldlWithKey' f z (Nest m) = Map.foldlWithKey' f z m

-- | /O(n)/. Strictly fold the keys and values in the 'DeepMap' using the given left-associative binary operator.
foldlWithKey1' :: (b -> k -> v -> b) -> b -> DeepMap '[k] v -> b
foldlWithKey1' f z m = foldlWithKey' (\b k (Bare v) -> f b k v) z m

-- | /O(n)/. Strictly fold the keys and values in the 'DeepMap' using the given left-associative binary operator.
foldlWithKey2' :: (b -> k0 -> k1 -> v -> b) -> b -> DeepMap '[k0, k1] v -> b
foldlWithKey2' f z m = foldlWithKey' (\b k0 -> foldlWithKey1' (`f` k0) b) z m

-- | /O(n)/. Strictly fold the keys and values in the 'DeepMap' using the given left-associative binary operator.
foldlWithKey3' :: (b -> k0 -> k1 -> k2 -> v -> b) -> b -> DeepMap '[k0, k1, k2] v -> b
foldlWithKey3' f z m = foldlWithKey (\b k0 -> foldlWithKey2' (`f` k0) b) z m

-- | /O(n)/. Strictly fold the keys and values in the 'DeepMap' using the given left-associative binary operator.
foldlWithKey4' :: (b -> k0 -> k1 -> k2 -> k3 -> v -> b) -> b -> DeepMap '[k0, k1, k2, k3] v -> b
foldlWithKey4' f z m = foldlWithKey' (\b k0 -> foldlWithKey3' (`f` k0) b) z m

-- | /O(n)/. Fold the keys and values in the 'DeepMap' using the given left-associative binary operator.
foldlWithKey5' :: (b -> k0 -> k1 -> k2 -> k3 -> k4 -> v -> b) -> b -> DeepMap '[k0, k1, k2, k3, k4] v -> b
foldlWithKey5' f z m = foldlWithKey' (\b k0 -> foldlWithKey4' (`f` k0) b) z m

-- | /O(n)/. Fold the keys and submaps using the given monoid.
foldMapWithKey :: (Monoid m) => (k -> DeepMap ks v -> m) -> DeepMap (k ': ks) v -> m
foldMapWithKey f (Nest m) = Map.foldMapWithKey f m

-- | /O(n)/. Fold the keys and values in the map using the given monoid.
foldMapWithKey1 :: (Monoid m) => (k -> v -> m) -> DeepMap '[k] v -> m
foldMapWithKey1 f m = foldMapWithKey (\k (Bare v) -> f k v) m

-- | /O(n)/. Fold the keys and values in the map using the given monoid.
foldMapWithKey2 :: (Monoid m) => (k0 -> k1 -> v -> m) -> DeepMap '[k0, k1] v -> m
foldMapWithKey2 f m = foldMapWithKey (foldMapWithKey1 . f) m

-- | /O(n)/. Fold the keys and values in the map using the given monoid.
foldMapWithKey3 :: (Monoid m) => (k0 -> k1 -> k2 -> v -> m) -> DeepMap '[k0, k1, k2] v -> m
foldMapWithKey3 f m = foldMapWithKey (foldMapWithKey2 . f) m

-- | /O(n)/. Fold the keys and values in the map using the given monoid.
foldMapWithKey4 :: (Monoid m) => (k0 -> k1 -> k2 -> k3 -> v -> m) -> DeepMap '[k0, k1, k2, k3] v -> m
foldMapWithKey4 f m = foldMapWithKey (foldMapWithKey3 . f) m

-- | /O(n)/. Fold the keys and values in the map using the given monoid.
foldMapWithKey5 :: (Monoid m) => (k0 -> k1 -> k2 -> k3 -> k4 -> v -> m) -> DeepMap '[k0, k1, k2, k3, k4] v -> m
foldMapWithKey5 f m = foldMapWithKey (foldMapWithKey4 . f) m

-- | /O(n)/. Strictly fold the keys and submaps using the given monoid.
foldMapWithKey' :: (Monoid m) => (k -> DeepMap ks v -> m) -> DeepMap (k ': ks) v -> m
foldMapWithKey' f (Nest m) = Map.foldMapWithKey' f m

-- | /O(n)/. Strictly fold the keys and values in the map using the given monoid.
foldMapWithKey1' :: (Monoid m) => (k -> v -> m) -> DeepMap '[k] v -> m
foldMapWithKey1' f m = foldMapWithKey' (\k (Bare v) -> f k v) m

-- | /O(n)/. Strictly fold the keys and values in the map using the given monoid.
foldMapWithKey2' :: (Monoid m) => (k0 -> k1 -> v -> m) -> DeepMap '[k0, k1] v -> m
foldMapWithKey2' f m = foldMapWithKey' (foldMapWithKey1' . f) m

-- | /O(n)/. Strictly fold the keys and values in the map using the given monoid.
foldMapWithKey3' :: (Monoid m) => (k0 -> k1 -> k2 -> v -> m) -> DeepMap '[k0, k1, k2] v -> m
foldMapWithKey3' f m = foldMapWithKey' (foldMapWithKey2' . f) m

-- | /O(n)/. Strictly fold the keys and values in the map using the given monoid.
foldMapWithKey4' :: (Monoid m) => (k0 -> k1 -> k2 -> k3 -> v -> m) -> DeepMap '[k0, k1, k2, k3] v -> m
foldMapWithKey4' f m = foldMapWithKey' (foldMapWithKey3' . f) m

-- | /O(n)/. Strictly fold the keys and values in the map using the given monoid.
foldMapWithKey5' :: (Monoid m) => (k0 -> k1 -> k2 -> k3 -> k4 -> v -> m) -> DeepMap '[k0, k1, k2, k3, k4] v -> m
foldMapWithKey5' f m = foldMapWithKey' (foldMapWithKey4' . f) m

-- | /O(n)/. Convert the map to a list of key/submap pairs where the keys are in ascending order.
--   Subject to list fusion.
toAscList :: DeepMap (k ': ks) v -> [(k, DeepMap ks v)]
toAscList (Nest m) = Map.toAscList m

-- | /O(n)/. Convert the map to a list of key/submap pairs where the keys are in descending order.
--   Subject to list fusion.
toDescList :: DeepMap (k ': ks) v -> [(k, DeepMap ks v)]
toDescList (Nest m) = Map.toDescList m

-- | /O(n)/. Filter all submaps that satisfy the predicate.
filter :: (DeepMap ks v -> Bool) -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
filter p (Nest m) = Nest $ Map.filter p m

-- | /O(n)/. Filter all values that satisfy the predicate.
filter1 :: (v -> Bool) -> DeepMap '[k] v -> DeepMap '[k] v
filter1 p (Nest m) = Nest $ Map.filter (p . getBare) m

-- | /O(n)/. Filter all values that satisfy the predicate.
filter2 :: (v -> Bool) -> DeepMap '[k0, k1] v -> DeepMap '[k0, k1] v
filter2 p m = mapDeep (filter1 p) $ filter (any p) m

-- | /O(n)/. Filter all values that satisfy the predicate.
filter3 :: (v -> Bool) -> DeepMap '[k0, k1, k2] v -> DeepMap '[k0, k1, k2] v
filter3 p m = mapDeep (filter2 p) $ filter (any p) m

-- | /O(n)/. Filter all values that satisfy the predicate.
filter4 :: (v -> Bool) -> DeepMap '[k0, k1, k2, k3] v -> DeepMap '[k0, k1, k2, k3] v
filter4 p m = mapDeep (filter3 p) $ filter (any p) m

-- | /O(n)/. Filter all values that satisfy the predicate.
filter5 :: (v -> Bool) -> DeepMap '[k0, k1, k2, k3, k4] v -> DeepMap '[k0, k1, k2, k3, k4] v
filter5 p m = mapDeep (filter4 p) $ filter (any p) m

-- | /O(n)/. Filter all key/submap pairs that satisfy the predicate.
filterWithKey :: (k -> DeepMap ks v -> Bool) -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
filterWithKey p (Nest m) = Nest $ Map.filterWithKey p m

-- | /O(n)/. Filter all key/value pairs that satisfy the predicate.
filterWithKey1 :: (k -> v -> Bool) -> DeepMap '[k] v -> DeepMap '[k] v
filterWithKey1 p m = runIdentity $ traverseMaybeWithKey1 (\k0 -> Identity . (guarded =<< p k0)) m

-- | /O(n)/. Filter all key-chain/value pairs that satisfy the predicate.
filterWithKey2 :: (k0 -> k1 -> v -> Bool) -> DeepMap '[k0, k1] v -> DeepMap '[k0, k1] v
filterWithKey2 p m = runIdentity $ traverseMaybeWithKey2 (\k0 k1 -> Identity . (guarded =<< p k0 k1)) m

-- | /O(n)/. Filter all key-chain/value pairs that satisfy the predicate.
filterWithKey3 :: (k0 -> k1 -> k2 -> v -> Bool) -> DeepMap '[k0, k1, k2] v -> DeepMap '[k0, k1, k2] v
filterWithKey3 p m = runIdentity $ traverseMaybeWithKey3 (\k0 k1 k2 -> Identity . (guarded =<< p k0 k1 k2)) m

-- | /O(n)/. Filter all key-chain/value pairs that satisfy the predicate.
filterWithKey4 :: (k0 -> k1 -> k2 -> k3 -> v -> Bool) -> DeepMap '[k0, k1, k2, k3] v -> DeepMap '[k0, k1, k2, k3] v
filterWithKey4 p m = runIdentity $ traverseMaybeWithKey4 (\k0 k1 k2 k3 -> Identity . (guarded =<< p k0 k1 k2 k3)) m

-- | /O(n)/. Filter all key-chain/value pairs that satisfy the predicate.
filterWithKey5 :: (k0 -> k1 -> k2 -> k3 -> k4 -> v -> Bool) -> DeepMap '[k0, k1, k2, k3, k4] v -> DeepMap '[k0, k1, k2, k3, k4] v
filterWithKey5 p m = runIdentity $ traverseMaybeWithKey5 (\k0 k1 k2 k3 k4 -> Identity . (guarded =<< p k0 k1 k2 k3 k4)) m

-- | /O(m log(n \/ m + 1)), m <= n/. Restrict a 'Map' to only the keys in a given 'Set'.
restrictKeys :: (Ord k) => DeepMap (k ': ks) v -> Set k -> DeepMap (k ': ks) v
restrictKeys (Nest m) s = Nest $ Map.restrictKeys m s

-- | /O(m log(n \/ m + 1)), m <= n/. Restrict a 'Map' to only the keys in a given 'Set'.
restrictKeys2 :: (Ord k0, Ord k1) => DeepMap (k0 ': k1 ': ks) v -> Set (k0, k1) -> DeepMap (k0 ': k1 ': ks) v
restrictKeys2 m s = mapDeep (\dm -> restrictKeys dm (Set.map snd s)) $ restrictKeys m (Set.map fst s)

-- | /O(m log(n \/ m + 1)), m <= n/. Restrict a 'Map' to only the keys in a given 'Set'.
restrictKeys3 :: (Ord k0, Ord k1, Ord k2) => DeepMap (k0 ': k1 ': k2 ': ks) v -> Set (k0, k1, k2) -> DeepMap (k0 ': k1 ': k2 ': ks) v
restrictKeys3 m s = mapDeep (\dm -> restrictKeys2 dm (Set.map (snd3 &&& thd3) s)) $ restrictKeys m (Set.map fst3 s)

-- | /O(m log(n \/ m + 1)), m <= n/. Restrict a 'Map' to only the keys in a given 'Set'.
restrictKeys4 :: (Ord k0, Ord k1, Ord k2, Ord k3) => DeepMap (k0 ': k1 ': k2 ': k3 ': ks) v -> Set (k0, k1, k2, k3) -> DeepMap (k0 ': k1 ': k2 ': k3 ': ks) v
restrictKeys4 m s = mapDeep (\dm -> restrictKeys3 dm (Set.map (\(_, b, c, d) -> (b, c, d)) s)) $ restrictKeys m (Set.map (\(a, _, _, _) -> a) s)

-- | /O(m log(n \/ m + 1)), m <= n/. Restrict a 'Map' to only the keys in a given 'Set'.
restrictKeys5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => DeepMap (k0 ': k1 ': k2 ': k3 ': k4 ': ks) v -> Set (k0, k1, k2, k3, k4) -> DeepMap (k0 ': k1 ': k2 ': k3 ': k4 ': ks) v
restrictKeys5 m s = mapDeep (\dm -> restrictKeys4 dm (Set.map (\(_, b, c, d, e) -> (b, c, d, e)) s)) $ restrictKeys m (Set.map (\(a, _, _, _, _) -> a) s)

-- | /O(m log(n \/ m + 1)), m <= n/. Remove all the keys in a 'Set' from a 'Map'.
withoutKeys :: (Ord k) => DeepMap (k ': ks) v -> Set k -> DeepMap (k ': ks) v
withoutKeys (Nest m) s = Nest $ Map.withoutKeys m s

-- | /O(m log(n \/ m + 1)), m <= n/. Remove all the keys in a 'Set' from a 'Map'.
withoutKeys2 :: (Ord k0, Ord k1) => DeepMap (k0 ': k1 ': ks) v -> Set (k0, k1) -> DeepMap (k0 ': k1 ': ks) v
withoutKeys2 m s = mapDeep (\dm -> withoutKeys dm (Set.map snd s)) $ withoutKeys m (Set.map fst s)

-- | /O(m log(n \/ m + 1)), m <= n/. Remove all the keys in a 'Set' from a 'Map'.
withoutKeys3 :: (Ord k0, Ord k1, Ord k2) => DeepMap (k0 ': k1 ': k2 ': ks) v -> Set (k0, k1, k2) -> DeepMap (k0 ': k1 ': k2 ': ks) v
withoutKeys3 m s = mapDeep (\dm -> withoutKeys2 dm (Set.map (snd3 &&& thd3) s)) $ withoutKeys m (Set.map fst3 s)

-- | /O(m log(n \/ m + 1)), m <= n/. Remove all the keys in a 'Set' from a 'Map'.
withoutKeys4 :: (Ord k0, Ord k1, Ord k2, Ord k3) => DeepMap (k0 ': k1 ': k2 ': k3 ': ks) v -> Set (k0, k1, k2, k3) -> DeepMap (k0 ': k1 ': k2 ': k3 ': ks) v
withoutKeys4 m s = mapDeep (\dm -> withoutKeys3 dm (Set.map (\(_, b, c, d) -> (b, c, d)) s)) $ withoutKeys m (Set.map (\(a, _, _, _) -> a) s)

-- | /O(m log(n \/ m + 1)), m <= n/. Remove all the keys in a 'Set' from a 'Map'.
withoutKeys5 :: (Ord k0, Ord k1, Ord k2, Ord k3, Ord k4) => DeepMap (k0 ': k1 ': k2 ': k3 ': k4 ': ks) v -> Set (k0, k1, k2, k3, k4) -> DeepMap (k0 ': k1 ': k2 ': k3 ': k4 ': ks) v
withoutKeys5 m s = mapDeep (\dm -> withoutKeys4 dm (Set.map (\(_, b, c, d, e) -> (b, c, d, e)) s)) $ withoutKeys m (Set.map (\(a, _, _, _, _) -> a) s)

-- | /O(n)/. Partition the map according to a predicate (satisfied, failed).
partition :: (DeepMap ks v -> Bool) -> DeepMap (k ': ks) v -> (DeepMap (k ': ks) v, DeepMap (k ': ks) v)
partition p (Nest m) = (Nest *** Nest) $ Map.partition p m

-- | /O(n)/. Partition the map according to a predicate (satisfied, failed).
partition1 :: (v -> Bool) -> DeepMap '[k] v -> (DeepMap '[k] v, DeepMap '[k] v)
partition1 p m = partition (p . getBare) m

-- | /O(n)/. Partition the map according to a predicate (satisfied, failed).
partition2 :: (v -> Bool) -> DeepMap '[k0, k1] v -> (DeepMap '[k0, k1] v, DeepMap '[k0, k1] v)
partition2 p m = (filter2 p &&& filter2 (not . p)) m

-- | /O(n)/. Partition the map according to a predicate (satisfied, failed).
partition3 :: (v -> Bool) -> DeepMap '[k0, k1, k2] v -> (DeepMap '[k0, k1, k2] v, DeepMap '[k0, k1, k2] v)
partition3 p m = (filter3 p &&& filter3 (not . p)) m

-- | /O(n)/. Partition the map according to a predicate (satisfied, failed).
partition4 :: (v -> Bool) -> DeepMap '[k0, k1, k2, k3] v -> (DeepMap '[k0, k1, k2, k3] v, DeepMap '[k0, k1, k2, k3] v)
partition4 p m = (filter4 p &&& filter4 (not . p)) m

-- | /O(n)/. Partition the map according to a predicate (satisfied, failed).
partition5 :: (v -> Bool) -> DeepMap '[k0, k1, k2, k3, k4] v -> (DeepMap '[k0, k1, k2, k3, k4] v, DeepMap '[k0, k1, k2, k3, k4] v)
partition5 p m = (filter5 p &&& filter5 (not . p)) m

-- | /O(n)/. Partition the map according to a predicate (satisfied, failed).
partitionWithKey :: (k -> DeepMap ks v -> Bool) -> DeepMap (k ': ks) v -> (DeepMap (k ': ks) v, DeepMap (k ': ks) v)
partitionWithKey p (Nest m) = (Nest *** Nest) $ Map.partitionWithKey p m

-- | /O(n)/. Partition the map according to a predicate (satisfied, failed).
partitionWithKey1 :: (k -> v -> Bool) -> DeepMap '[k] v -> (DeepMap '[k] v, DeepMap '[k] v)
partitionWithKey1 p m = partitionWithKey (\k -> p k . getBare) m

-- | /O(n)/. Partition the map according to a predicate (satisfied, failed).
partitionWithKey2 :: (k0 -> k1 -> v -> Bool) -> DeepMap '[k0, k1] v -> (DeepMap '[k0, k1] v, DeepMap '[k0, k1] v)
partitionWithKey2 p m = (filterWithKey2 p &&& filterWithKey2 (\k0 k1 -> not . p k0 k1)) m

-- | /O(n)/. Partition the map according to a predicate (satisfied, failed).
partitionWithKey3 :: (k0 -> k1 -> k2 -> v -> Bool) -> DeepMap '[k0, k1, k2] v -> (DeepMap '[k0, k1, k2] v, DeepMap '[k0, k1, k2] v)
partitionWithKey3 p m = (filterWithKey3 p &&& filterWithKey3 (\k0 k1 k2 -> not . p k0 k1 k2)) m

-- | /O(n)/. Partition the map according to a predicate (satisfied, failed).
partitionWithKey4 :: (k0 -> k1 -> k2 -> k3 -> v -> Bool) -> DeepMap '[k0, k1, k2, k3] v -> (DeepMap '[k0, k1, k2, k3] v, DeepMap '[k0, k1, k2, k3] v)
partitionWithKey4 p m = (filterWithKey4 p &&& filterWithKey4 (\k0 k1 k2 k3 -> not . p k0 k1 k2 k3)) m

-- | /O(n)/. Partition the map according to a predicate (satisfied, failed).
partitionWithKey5 :: (k0 -> k1 -> k2 -> k3 -> k4 -> v -> Bool) -> DeepMap '[k0, k1, k2, k3, k4] v -> (DeepMap '[k0, k1, k2, k3, k4] v, DeepMap '[k0, k1, k2, k3, k4] v)
partitionWithKey5 p m = (filterWithKey5 p &&& filterWithKey5 (\k0 k1 k2 k3 k4 -> not . p k0 k1 k2 k3 k4)) m

-- | /O(n)/. Take while a predicate on the keys holds. See the note at 'spanAntitone'.
takeWhileAntitone :: (k -> Bool) -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
takeWhileAntitone p (Nest m) = Nest $ Map.takeWhileAntitone p m

-- | /O(n)/. Drop while a predicate on the keys holds. See the note at 'spanAntitone'.
dropWhileAntitone :: (k -> Bool) -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
dropWhileAntitone p (Nest m) = Nest $ Map.dropWhileAntitone p m

-- | /O(n)/. Take while a predicate on the keys holds.
--
--   __NOTE:__ if p is not actually antitone, then 'spanAntitone' will split the map
--   at some unspecified point where the predicate switches from holding to not holding
--   (where the predicate is seen to hold before the first key and to fail after the last key).
spanAntitone :: (k -> Bool) -> DeepMap (k ': ks) v -> (DeepMap (k ': ks) v, DeepMap (k ': ks) v)
spanAntitone p (Nest m) = Nest *** Nest $ Map.spanAntitone p m

-- | /O(n)/. Map values and collect the 'Just' results.
fmapMaybe :: (v -> Maybe w) -> DeepMap (k ': ks) v -> DeepMap (k ': ks) w
fmapMaybe f (Nest m) = Nest $ Map.mapMaybe (traverse f) m

-- | /O(n)/. Map values and collect the 'Just' results. Strictly more general than 'fmapMaybe' in that the types of the inner keys can change.
mapDeepMaybe :: (DeepMap ks v -> Maybe (DeepMap ls w)) -> DeepMap (k ': ks) v -> DeepMap (k ': ls) w
mapDeepMaybe f (Nest m) = Nest $ Map.mapMaybe f m

-- | /O(n)/. Map values and collect the 'Just' results.
mapDeepMaybeWithKey :: (k -> DeepMap ks v -> Maybe (DeepMap ls w)) -> DeepMap (k ': ks) v -> DeepMap (k ': ls) w
mapDeepMaybeWithKey f (Nest m) = Nest $ Map.mapMaybeWithKey f m

-- | /O(n)/. Map values and collect the 'Just' results.
mapDeepMaybeWithKey1 :: (k -> v -> Maybe w) -> DeepMap '[k] v -> DeepMap '[k] w
mapDeepMaybeWithKey1 f m = mapDeepMaybeWithKey (\k -> fmap Bare . f k . getBare) m

-- | /O(n)/. Map values and collect the 'Just' results.
mapDeepMaybeWithKey2 :: (k0 -> k1 -> v -> Maybe w) -> DeepMap '[k0, k1] v -> DeepMap '[k0, k1] w
mapDeepMaybeWithKey2 f m =
    let g k0 k1 v = Identity $ f k0 k1 v
     in runIdentity $ traverseMaybeWithKey (fmap (fmap Just) . traverseMaybeWithKey1 . g) m

-- | /O(n)/. Map values and collect the 'Just' results.
mapDeepMaybeWithKey3 :: (k0 -> k1 -> k2 -> v -> Maybe w) -> DeepMap '[k0, k1, k2] v -> DeepMap '[k0, k1, k2] w
mapDeepMaybeWithKey3 f m =
    let g k0 k1 k2 v = Identity $ f k0 k1 k2 v
     in runIdentity $ traverseMaybeWithKey (fmap (fmap Just) . traverseMaybeWithKey2 . g) m

-- | /O(n)/. Map values and collect the 'Just' results.
mapDeepMaybeWithKey4 :: (k0 -> k1 -> k2 -> k3 -> v -> Maybe w) -> DeepMap '[k0, k1, k2, k3] v -> DeepMap '[k0, k1, k2, k3] w
mapDeepMaybeWithKey4 f m =
    let g k0 k1 k2 k3 v = Identity $ f k0 k1 k2 k3 v
     in runIdentity $ traverseMaybeWithKey (fmap (fmap Just) . traverseMaybeWithKey3 . g) m

-- | /O(n)/. Map values and collect the 'Just' results.
mapDeepMaybeWithKey5 :: (k0 -> k1 -> k2 -> k3 -> k4 -> v -> Maybe w) -> DeepMap '[k0, k1, k2, k3, k4] v -> DeepMap '[k0, k1, k2, k3, k4] w
mapDeepMaybeWithKey5 f m =
    let g k0 k1 k2 k3 k4 v = Identity $ f k0 k1 k2 k3 k4 v
     in runIdentity $ traverseMaybeWithKey (fmap (fmap Just) . traverseMaybeWithKey4 . g) m

-- | /O(n)/. Map values and collect the 'Left' and 'Right' results separately.
mapEither :: (DeepMap ks v -> Either (DeepMap ls w) (DeepMap ms x)) -> DeepMap (k ': ks) v -> (DeepMap (k ': ls) w, DeepMap (k ': ms) x)
mapEither f (Nest m) = Nest *** Nest $ Map.mapEither f m

-- | /O(n)/. Map values and collect the 'Left' and 'Right' results separately.
mapEither1 :: (v -> Either w x) -> DeepMap '[k] v -> (DeepMap '[k] w, DeepMap '[k] x)
mapEither1 f m = mapEither ((Bare +++ Bare) . f . getBare) m

-- | /O(n)/. Map values and collect the 'Left' and 'Right' results separately.
mapEither2 :: (v -> Either w x) -> DeepMap '[k0, k1] v -> (DeepMap '[k0, k1] w, DeepMap '[k0, k1] x)
mapEither2 f m =
    (fmapMaybe keepLeft *** fmapMaybe keepRight) . partition2 isLeft $
        mapDeep (mapDeep $ fmap f) m

-- | /O(n)/. Map values and collect the 'Left' and 'Right' results separately.
mapEither3 :: (v -> Either w x) -> DeepMap '[k0, k1, k2] v -> (DeepMap '[k0, k1, k2] w, DeepMap '[k0, k1, k2] x)
mapEither3 f m =
    (fmapMaybe keepLeft *** fmapMaybe keepRight) . partition3 isLeft $
        mapDeep (mapDeep . mapDeep $ fmap f) m

-- | /O(n)/. Map values and collect the 'Left' and 'Right' results separately.
mapEither4 :: (v -> Either w x) -> DeepMap '[k0, k1, k2, k3] v -> (DeepMap '[k0, k1, k2, k3] w, DeepMap '[k0, k1, k2, k3] x)
mapEither4 f m =
    (fmapMaybe keepLeft *** fmapMaybe keepRight) . partition4 isLeft $
        mapDeep (mapDeep . mapDeep . mapDeep $ fmap f) m

-- | /O(n)/. Map values and collect the 'Left' and 'Right' results separately.
mapEither5 :: (v -> Either w x) -> DeepMap '[k0, k1, k2, k3, k4] v -> (DeepMap '[k0, k1, k2, k3, k4] w, DeepMap '[k0, k1, k2, k3, k4] x)
mapEither5 f m =
    (fmapMaybe keepLeft *** fmapMaybe keepRight) . partition5 isLeft $
        mapDeep (mapDeep . mapDeep . mapDeep . mapDeep $ fmap f) m

-- | /O(n)/. Map values and collect the 'Left' and 'Right' results separately.
mapEitherWithKey :: (k -> DeepMap ks v -> Either (DeepMap ls w) (DeepMap ms x)) -> DeepMap (k ': ks) v -> (DeepMap (k ': ls) w, DeepMap (k ': ms) x)
mapEitherWithKey f (Nest m) = Nest *** Nest $ Map.mapEitherWithKey f m

-- | /O(n)/. Map values and collect the 'Left' and 'Right' results separately.
mapEitherWithKey1 :: (k -> v -> Either w x) -> DeepMap '[k] v -> (DeepMap '[k] w, DeepMap '[k] x)
mapEitherWithKey1 f (Nest m) = Nest *** Nest $ Map.mapEitherWithKey (\k -> (Bare +++ Bare) . f k . getBare) m

-- | /O(n)/. Map values and collect the 'Left' and 'Right' results separately.
mapEitherWithKey2 :: (k0 -> k1 -> v -> Either w x) -> DeepMap '[k0, k1] v -> (DeepMap '[k0, k1] w, DeepMap '[k0, k1] x)
mapEitherWithKey2 f m =
    (fmapMaybe keepLeft *** fmapMaybe keepRight) . partition2 isLeft $
        mapDeepWithKey (\k0 -> mapDeepWithKey $ fmap . f k0) m

-- | /O(n)/. Map values and collect the 'Left' and 'Right' results separately.
mapEitherWithKey3 :: (k0 -> k1 -> k2 -> v -> Either w x) -> DeepMap '[k0, k1, k2] v -> (DeepMap '[k0, k1, k2] w, DeepMap '[k0, k1, k2] x)
mapEitherWithKey3 f m =
    (fmapMaybe keepLeft *** fmapMaybe keepRight) . partition3 isLeft $
        mapDeepWithKey
            ( \k0 -> mapDeepWithKey $ \k1 ->
                mapDeepWithKey $ fmap . f k0 k1
            )
            m

-- | /O(n)/. Map values and collect the 'Left' and 'Right' results separately.
mapEitherWithKey4 :: (k0 -> k1 -> k2 -> k3 -> v -> Either w x) -> DeepMap '[k0, k1, k2, k3] v -> (DeepMap '[k0, k1, k2, k3] w, DeepMap '[k0, k1, k2, k3] x)
mapEitherWithKey4 f m =
    (fmapMaybe keepLeft *** fmapMaybe keepRight) . partition4 isLeft $
        mapDeepWithKey
            ( \k0 -> mapDeepWithKey $ \k1 ->
                mapDeepWithKey $ \k2 ->
                    mapDeepWithKey $ fmap . f k0 k1 k2
            )
            m

-- | /O(n)/. Map values and collect the 'Left' and 'Right' results separately.
mapEitherWithKey5 :: (k0 -> k1 -> k2 -> k3 -> k4 -> v -> Either w x) -> DeepMap '[k0, k1, k2, k3, k4] v -> (DeepMap '[k0, k1, k2, k3, k4] w, DeepMap '[k0, k1, k2, k3, k4] x)
mapEitherWithKey5 f m =
    (fmapMaybe keepLeft *** fmapMaybe keepRight) . partition5 isLeft $
        mapDeepWithKey
            ( \k0 -> mapDeepWithKey $ \k1 ->
                mapDeepWithKey $ \k2 ->
                    mapDeepWithKey $ \k3 ->
                        mapDeepWithKey $ fmap . f k0 k1 k2 k3
            )
            m

-- | /O(log n)/. Partition the map by comparing keys ((smaller, larger) than given).
split :: (Ord k) => k -> DeepMap (k ': ks) v -> (DeepMap (k ': ks) v, DeepMap (k ': ks) v)
split k (Nest m) = Nest *** Nest $ Map.split k m

-- | /O(log n)/. Like 'split' but the middle coordinate 'lookup's the value at the key.
splitLookup :: (Ord k) => k -> DeepMap (k ': ks) v -> (DeepMap (k ': ks) v, Maybe (DeepMap ks v), DeepMap (k ': ks) v)
splitLookup k (Nest m) = (\(n, y, p) -> (Nest n, y, Nest p)) $ Map.splitLookup k m

-- | /O(1)/. Decompose a map into pieces based on the structure of the underlying tree.
splitRoot :: DeepMap (k ': ks) v -> [DeepMap (k ': ks) v]
splitRoot (Nest m) = Nest <$> Map.splitRoot m

-- | /O(m log(n \/ m + 1)), m <= n/. Returns 'True' if all the keys in the left map
--   exist in the right, __and__ their values all agree.
isSubmapOf :: (Ord k, Eq (DeepMap ks v)) => DeepMap (k ': ks) v -> DeepMap (k ': ks) v -> Bool
isSubmapOf (Nest m) (Nest n) = Map.isSubmapOf m n

-- | /O(m log(n \/ m + 1)), m <= n/. Returns 'True' if all the keys in the left map
--   exist in the right, __and__ the function returns 'True' when applied to respective values.
isSubmapOfBy :: (Ord k) => (DeepMap ks v -> DeepMap ks v -> Bool) -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v -> Bool
isSubmapOfBy f (Nest m) (Nest n) = Map.isSubmapOfBy f m n

-- | /O(m log(n \/ m + 1)), m <= n/. Returns 'True' if all the keys in the left map
--   exist in the right, __and__ their values all agree, __and__ the maps are not equal.
isProperSubmapOf :: (Ord k, Eq (DeepMap ks v)) => DeepMap (k ': ks) v -> DeepMap (k ': ks) v -> Bool
isProperSubmapOf (Nest m) (Nest n) = Map.isProperSubmapOf m n

-- | /O(m log(n \/ m + 1)), m <= n/. Returns 'True' if all the keys in the left map
--   exist in the right, __and__ the function returns 'True' when applied to respective values,
--   __and__ the maps are not equal.
isProperSubmapOfBy :: (Ord k) => (DeepMap ks v -> DeepMap ks v -> Bool) -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v -> Bool
isProperSubmapOfBy f (Nest m) (Nest n) = Map.isProperSubmapOfBy f m n

-- | /O(log n)/. Lookup the /index/ of a key, which is its zero-based index
--   in the ordered sequence of keys.
--
-- > 'lookupIndex' k m == 'Data.List.findIndex' k ('keys' m)
lookupIndex :: (Ord k) => k -> DeepMap (k ': ks) v -> Maybe Int
lookupIndex k (Nest m) = Map.lookupIndex k m

-- | /O(log n)/. Lookup the /index/ of a key, which is its zero-based index
--   in the ordered sequence of keys. Calls 'error' when the key is not in the map.
findIndex :: (Ord k) => k -> DeepMap (k ': ks) v -> Int
findIndex i (Nest m) = Map.findIndex i m

-- | /O(log n)/. Retrieve an element by its /index/. Calls 'error' if @i@ is outside
--   the range @0 <= i < 'size' m@.
elemAt :: (Ord k) => Int -> DeepMap (k ': ks) v -> (k, DeepMap ks v)
elemAt i (Nest m) = Map.elemAt i m

-- | /O(log n)/. Update the element by its /index/. Calls 'error' if @i@ is outside
--   the range @0 <= i < 'size' m@.
updateAt :: (Ord k) => (k -> DeepMap ks v -> Maybe (DeepMap ks v)) -> Int -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
updateAt f i (Nest m) = Nest $ Map.updateAt f i m

-- | /O(log n)/. Delete the element by its /index/. Calls 'error' if @i@ is outside
--   the range @0 <= i < 'size' m@.
deleteAt :: (Ord k) => (k -> DeepMap ks v -> Maybe (DeepMap ks v)) -> Int -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
deleteAt f i (Nest m) = Nest $ Map.updateAt f i m

-- | Take the smallest @n@ keys.
take :: Int -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
take n (Nest m) = Nest $ Map.take n m

-- | Drop the smallest @n@ keys.
drop :: Int -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
drop n (Nest m) = Nest $ Map.take n m

-- | /O(n)/. Split a map at a particular index.
splitAt :: Int -> DeepMap (k ': ks) v -> (DeepMap (k ': ks) v, DeepMap (k ': ks) v)
splitAt i (Nest m) = Nest *** Nest $ Map.splitAt i m

-- | /O(log n)/. The minimal key of the map, or 'Nothing' if the map is empty.
lookupMin :: DeepMap (k ': ks) v -> Maybe (k, DeepMap ks v)
lookupMin (Nest m) = Map.lookupMin m

-- | /O(log n)/. The maximal key of the map, or 'Nothing' if the map is empty.
lookupMax :: DeepMap (k ': ks) v -> Maybe (k, DeepMap ks v)
lookupMax (Nest m) = Map.lookupMax m

-- | /O(log n)/. The minimal key of the map, or 'error' if the map is empty.
findMin :: DeepMap (k ': ks) v -> (k, DeepMap ks v)
findMin (Nest m) = Map.findMin m

-- | /O(log n)/. The maximal key of the map, or 'error' if the map is empty.
findMax :: DeepMap (k ': ks) v -> (k, DeepMap ks v)
findMax (Nest m) = Map.findMax m

-- | /O(log n)/. Delete the minimal key.
deleteMin :: DeepMap (k ': ks) v -> DeepMap (k ': ks) v
deleteMin (Nest m) = Nest $ Map.deleteMin m

-- | /O(log n)/. Delete the maximal key.
deleteMax :: DeepMap (k ': ks) v -> DeepMap (k ': ks) v
deleteMax (Nest m) = Nest $ Map.deleteMax m

-- | /O(log n)/. Delete and return the minimal key of the map, or 'error' if the map is empty.
deleteFindMin :: DeepMap (k ': ks) v -> ((k, DeepMap ks v), DeepMap (k ': ks) v)
deleteFindMin (Nest m) = Nest <$> Map.deleteFindMin m

-- | /O(log n)/. Delete and return the maximal key of the map, or 'error' if the map is empty.
deleteFindMax :: DeepMap (k ': ks) v -> ((k, DeepMap ks v), DeepMap (k ': ks) v)
deleteFindMax (Nest m) = Nest <$> Map.deleteFindMax m

-- | /O(log n)/. Update the value at the minimal key.
updateMin :: (DeepMap ks v -> Maybe (DeepMap ks v)) -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
updateMin f (Nest m) = Nest $ Map.updateMin f m

-- | /O(log n)/. Update the value at the maximal key.
updateMax :: (DeepMap ks v -> Maybe (DeepMap ks v)) -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
updateMax f (Nest m) = Nest $ Map.updateMax f m

-- | /O(log n)/. Update the value at the minimal key.
updateMinWithKey :: (k -> DeepMap ks v -> Maybe (DeepMap ks v)) -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
updateMinWithKey f (Nest m) = Nest $ Map.updateMinWithKey f m

-- | /O(log n)/. Update the value at the maximal key.
updateMaxWithKey :: (k -> DeepMap ks v -> Maybe (DeepMap ks v)) -> DeepMap (k ': ks) v -> DeepMap (k ': ks) v
updateMaxWithKey f (Nest m) = Nest $ Map.updateMaxWithKey f m

-- | /O(log n)/. Retrieve the value associated with the minimal key of the map,
--   and the map stripped of that element, or 'Nothing' if passed an empty map.
minView :: DeepMap (k ': ks) v -> Maybe (DeepMap ks v, DeepMap (k ': ks) v)
minView (Nest m) = fmap Nest <$> Map.minView m

-- | /O(log n)/. Retrieve the value associated with the maximal key of the map,
--   and the map stripped of that element, or 'Nothing' if passed an empty map.
maxView :: DeepMap (k ': ks) v -> Maybe (DeepMap ks v, DeepMap (k ': ks) v)
maxView (Nest m) = fmap Nest <$> Map.maxView m

-- | /O(log n)/. Retrieve the minimal key/value pair of the map,
--   and the map stripped of that element, or 'Nothing' if passed an empty map.
minViewWithKey :: DeepMap (k ': ks) v -> Maybe ((k, DeepMap ks v), DeepMap (k ': ks) v)
minViewWithKey (Nest m) = fmap Nest <$> Map.minViewWithKey m

-- | /O(log n)/. Retrieve the maximal key/value pair of the map,
--   and the map stripped of that element, or 'Nothing' if passed an empty map.
maxViewWithKey :: DeepMap (k ': ks) v -> Maybe ((k, DeepMap ks v), DeepMap (k ': ks) v)
maxViewWithKey (Nest m) = fmap Nest <$> Map.maxViewWithKey m

-- | "Transpose" a 'DeepMap', by swapping the outer two "dimensions".
invertKeys :: (Ord j, Ord k, Semigroup (DeepMap ks v)) => DeepMap (j ': k ': ks) v -> DeepMap (k ': j ': ks) v
invertKeys m = fold [k @> j @> mv | (j, mk) <- assocs m, (k, mv) <- assocs mk]
