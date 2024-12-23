import System.IO
import Data.List
import Data.Char

-- split string on whitespace and cast words to int
parseLine :: String -> [Int]
parseLine = map read . words 

-- check each pair of values is in asc order
-- produce a list of bool results
-- then AND that list
-- read right to left
isAscending :: [Int] -> Bool
isAscending xs = and $ zipWith (<=) xs (tail xs)

-- check each pair of values is in desc order
-- produce a list of bool results
-- then AND that list
-- read right to left
isDescending :: [Int] -> Bool
isDescending xs = and $ zipWith (>=) xs (tail xs)

-- check if list is in asc or desc order
isAscendingOrDescending :: [Int] -> Bool
isAscendingOrDescending xs = isAscending xs || isDescending xs

-- check each pair of values is in asc order
-- produce a list of bool results
-- then AND that list
-- read right to left
validDistance :: [Int] -> Bool
validDistance xs = and $ map isValidDist $ zip xs (tail xs) -- check each pair in list
  where isValidDist (a, b) = dist a b >= 1 && dist a b <= 3 -- require dist between 1 & 3
        dist x y = abs (x - y) -- check dist by getting the absolute value of x-y

isValidAfterRemoval :: [Int] -> Bool
isValidAfterRemoval xs = any isValid (possibleRemovals xs)
 where
   -- make a list of lists with one element removed
   -- loop through indices in the list and make new
   -- lists by concatting (++) the sublist before i
   -- with the sublist after i
   possibleRemovals lst = [take i lst ++ drop (i+1) lst | i <- [0..length lst - 1]]
   isValid lst = isAscendingOrDescending lst && validDistance lst

main :: IO ()
main = do
   contents <- readFile "input.txt"
   let listOfLists = map parseLine (lines contents)
   let results = map (\xs -> isAscendingOrDescending xs && validDistance xs) listOfLists
   let removalResults = map isValidAfterRemoval listOfLists
   print "Total number of valid lists:"
   print $ length $ filter id results
   print "Total number of lists valid after removing one number:"
   print $ length $ filter id removalResults