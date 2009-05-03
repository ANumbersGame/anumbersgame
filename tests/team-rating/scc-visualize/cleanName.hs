import Char

main =
    do s <- getContents;
       putStr $ filter good s

good x =
    isAlphaNum x || x == ' '
