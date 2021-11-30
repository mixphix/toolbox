# Changelog for toolbox

## v0.3.1.0
Add `groupAll :: (Ord a) => [a] -> [NonEmpty a]`

## v0.3.0.0
Removes monoidal containers (`Data.Map.Monoidal.*~, Data.IntMap.Monoidal.*`) from the package in favour of `monoidal-containers` and `deep-map`.

## v0.2.0.0
This release delivers a strict, nested map type called `DeepMap`, parametrized by a type-level list of keys reaching a single value type, which is ideally a `Semigroup`. The interface is presented in the style of `Data.Map` from the `containers` package, with additional versions of common functions for ease of use with `DeepMap`s of depth up to 5.

## v0.1.2.0
New functions:
- `Data.Map.Monoidal`
  - `invertKeys :: (Ord j, Ord k, Semigroup a) => Map j (Map k a) -> Map k (Map j a)`
- `Control.Monad.Toolbox`
  - `(<<$>>) :: (Functor f, Functor g) => (a -> b) -> g (f a) -> g (f b)`
  - Re-export `Data.Functor`
Documentation fixes in `Data.Map.Monoidal`

## v0.1.1.0
New functions:
- `Data.Tuple.Toolbox`
  - `firstF :: (Functor f) => (a -> f b) -> (a, x) -> f (b, x)`
  - `secondF :: (Functor f) => (a -> f b) -> (x, a) -> f (x, b)`
  - friends of the above for higher tuples
  - `toFirst :: (Functor f) => (a -> f b) -> a -> f (b, a)`
  - `toSecond :: (Functor f) => (a -> f b) -> a -> f (a, b)`
  - `unpairFst :: ((a, b), c) -> (a, b, c)`
  - `unpairSnd :: (a, (b, c)) -> (a, b, c)`
  - `pairFst :: (a, b, c) -> ((a, b), c)`
  - `pairSnd :: (a, b, c) -> (a, (b, c))`
  - `dup :: a -> (a, a)`
- `Data.List.Toolbox.unsnoc :: [a] -> Maybe ([a], a)`
- `Data.List.NonEmpty.Toolbox`
  - `withNonEmpty :: [a] -> (NonEmpty a -> b) -> Maybe b`
  - `whenNonEmpty :: (Monad m) => [a] -> (NonEmpty a -> m ()) -> m ()`
  - `whenNonEmptyM :: (Monad m) => m [a] -> (NonEmpty a -> m ()) -> m ()`
Bug fixes:
- `Data.Time.Timeframe`
  - `intersect` now properly calculates intersections and supports instantaneous overlaps
  - `unions` is now terminating

## v0.1.0.0
The first release contains a small selection of useful functions over the `base` libraries, as well as convenient alternative class implementations for map types from the `containers` library.

- `Data.Map.Monoidal` and `Data.IntMap.Monoidal`
  - Both strict and lazy versions
  - Interface designed to closely match the `containers` versions
- `Data.Time.Timeframe`
  - Bounded and unbounded time intervals
  - Unions and intersections of timeframes
- `M.Toolbox` utilities
  - Additional functions with intuitive names
