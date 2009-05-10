{-# LANGUAGE ScopedTypeVariables #-}

import List
import qualified Data.Map as M

aggregate [] x = x
aggregate ((k,v):r) x =
    aggregate r $ M.insertWith (+) k v x

main = 
    do
      cont <- getContents
      let oper = lines cont
      let good = filter (not . null) oper
      let vals :: [(Float, Int)] = map read good
      let histo = aggregate vals M.empty
      print histo
      let sizes = map snd $ M.toList histo
      print $ sum sizes