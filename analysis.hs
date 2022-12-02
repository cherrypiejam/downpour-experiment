-- stack runghc analysis.hs --package regex-tdfa

import System.IO
import Control.Monad
import Control.Exception
import Data.List
import Text.Regex.TDFA

avg :: (Real a, Fractional b) => [a] -> b
avg [] = 0
avg l = (realToFrac . sum) l / (realToFrac . length) l

main :: IO ()
main = do
    let r  = "Status: Downloading, Progress: [0-9]+%, Peers: [0-9]+, \
             \Speed: [0-9]+K/s, ETA: [A-Za-z0-9?]+, Upload Speed [0-9]+K/s"
        r' = "[0-9]+[^hms]"
        d  = "result/0/seed/" :
             ["result/" ++ show n ++ "/" ++ show p ++ "/" | n <- [0..4],
                                                            p <- [1..5]]
    forM_ d (\d' -> do
        handle <- try $ openFile (d' ++ "stats.log") ReadMode :: IO (Either SomeException Handle)
        case handle of
            Left ex -> print ex
            Right f -> do
                print f
                contents <- hGetContents f
                let logs = [l'' | l <- lines contents,
                            l =~ r :: Bool,
                            let l'  = getAllTextMatches (l =~ r') :: [String],
                            let l'' = map (read . init) l' :: [Int]]
                    progresses = [head l | l <- logs]
                    peernums   = [l !! 1 | l <- logs]
                    downloads  = [l !! 2 | l <- logs]
                    uploads    = [l !! 3 | l <- logs]
                putStrLn $ "-> " ++
                           "avg dl: " ++ show (avg downloads) ++ "K/s, " ++
                           "avg ul: " ++ show (avg uploads) ++ "K/s, " ++
                           "avg peer nums: " ++ show (avg peernums) ++ ", " ++
                           "progress: " ++ show (foldr max 0 progresses)
                hClose f)

    -- file <- openFile "test.txt" ReadMode
    -- contents <- hGetContents file

    -- let logs = [l'' | l <- lines contents,
                      -- l =~ r :: Bool,
                      -- let l' = getAllTextMatches (l =~ r') :: [String],
                      -- let l''  = map (read . init) l' :: [Int]]
        -- progresses = [head l | l <- logs]
        -- peernums   = [l !! 1 | l <- logs]
        -- downloads  = [l !! 2 | l <- logs]
        -- uploads    = [l !! 3 | l <- logs]

    -- putStrLn $ "avg dl: " ++ show (avg downloads) ++ "K/s, " ++
               -- "avg ul: " ++ show (avg uploads) ++ "K/s, " ++
               -- "avg peer nums: " ++ show (avg peernums)

    -- let avg = \a -> realToFrac (sum a) / genericLength a
    -- let f = flip (=~) "[a-z]+"
    -- let logss = filter f $ lines contents
    -- mapM_ print logs
    -- return ()
