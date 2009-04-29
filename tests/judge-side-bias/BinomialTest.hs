{-# LANGUAGE NoMonomorphismRestriction #-}

module BinomialTest where

{- This module calculated the cumulative binomial distribution of a sample, given a likelihood for a population.-}

import Test.QuickCheck hiding (choose)
import List

chooseIter :: Num a => [a] -> [a]
chooseIter old = [1] ++ (zipWith (+) old (tail old)) ++ [1]

chooseList :: Num a => [[a]]
chooseList = iterate chooseIter [1]

(!!!) = genericIndex

choose n k = chooseList !!! n !!! k

{- This is just a QuickCheck test for the choose function -}
chooseTest nt kt = 
    let n = abs nt
        k = kt`mod`(1+n)
        ans = choose n k
    in if (k == 0) || (k == n)
       then ans == 1
       else ans == choose (n-1) (k-1) + choose (n-1) k


binomialTestLess _ 0 _ = 0
binomialTestLess n (k+1) p =
    sum [binomialTestAt n i p | i <- [0..k]]

binomialTestAt n k p = (choose n k) * (p^k) * ((1-p)^(n-k))

binomialTest :: Num a => Integer -> Integer -> a -> (a,a)
binomialTest n k p =
    if k > n-k
    then swap $ binomialTest n (n-k) (1-p)
    else let l = binomialTestLess n k p
             -- We count e twice, since we are interested in the likelihood of this bias or less.
             e = binomialTestAt n k p
             r = 1-l
         in (l+e,r)
    where
      swap (a,b) = (b,a)

-- toFloat (x,y) = (fromRational x, fromRational y)

-- main = print $ length $ show [choose 800 i | i <- [0..400]]
