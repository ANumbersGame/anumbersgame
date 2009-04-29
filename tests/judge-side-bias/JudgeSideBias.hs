{-# LANGUAGE NoMonomorphismRestriction #-}

module JudgeSideBias where

{- 
   This module calculates judge side bias and outputs it in a user-friendly or SQL-friendly way.
-}

import ReadDecPerJudge
import BinomialTest
import Ratio
import List
import Numeric

main = 
    do (m,decs) <- readDecPerJudge
       let (affBias,negBias) = unzip $ map (biasOf decs) m
       prettyPrint decs affBias negBias

dataPrint affBias negBias =
    do mapM print $ map dataOnly affBias
       putStrLn "--"
       mapM print $ map dataOnly affBias

dataOnly (v,(n,_),_,_) =
    (numerator v, denominator v, n)

prettyPrint decs affBias negBias =
    do putStr "Aff win rate: "
       putStrLn $ showPercent $ fromRational $ (fst decs)%((fst decs) + (snd decs))
       putStrLn "Aff bias:"
       mapM putStrLn $ printList $ sort affBias
       putStrLn "Neg bias:"
       mapM putStrLn $ printList $ sort negBias

biasOf (pro,con) (name,(aff,neg)) =
    let rat = (pro-aff)%(con-neg+pro-aff)
        (affFair,negFair) = binomialTest (aff+neg) aff rat
    in ((negFair,name,aff,neg),
        (affFair,name,aff,neg))

{-

We use this very simple and conservative condifence interval becuase of the analysis given in:

AU: Paul W. Vos, Suzanne Hudson
TI: PROBLEMS WITH BINOMIAL TWO-SIDED TESTS AND THE ASSOCIATED CONFIDENCE INTERVALS
SO: Australian & New Zealand Journal of Statistics
VL: 50
NO: 1
PG: 81-89
YR: 2008
CP: 2008 Australian Statistical Publishing Association Inc.
ON: 1467-842X
PN: 1369-1473
AD: East Carolina University
DOI: 10.1111/j.1467-842X.2007.00501.x
US: http://dx.doi.org/10.1111/j.1467-842X.2007.00501.x

-}

confidence v = 2*v

likelihood = 0.02

printList = 
    let sig (v,_,_,_) = confidence v < likelihood
    in map mprint . filter sig

mprint (v,(n,p),q,r) = 
    (showPercent $ fromRational $ confidence v)++" #"++(show n)++": "++p++", Aff:"++(show q)++", Neg:"++(show r)

showPercent v = showFFloat (Just 2) (100*v) "%"