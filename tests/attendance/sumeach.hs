{-# LANGUAGE ScopedTypeVariables #-}

import List
import qualified Data.Map as M

aggregate n xs = map sum $ transpose [a,b,c]
    where a = take n xs
          b = take n $ drop n xs
          c = drop n $ drop n xs

runAve n xs = 
    let m = length xs
    in if n > m
       then []
       else mean (take n xs) : runAve n (tail xs)
    where
      mean ys = fromIntegral (sum ys) / fromIntegral (length ys)

main = 
    do
      cont <- getContents
      let oper = lines cont
      let good = filter (not . null) oper
      let vals :: [Int] = map read good
      let histo = aggregate 78 vals
      print {- $ map (33.33333*) $ map fromIntegral -} histo
--      print histo
      mprint 9 9 $ {- map (33.3333*) $ -} runAve 20 histo
--      print $ length $ runAve 20 histo

mprint n m x = 
    print $ replicate n (-1) ++ x ++ replicate n (-1)

lprint [] = return ()
lprint (x:xs) = 
    do print x
       lprint xs