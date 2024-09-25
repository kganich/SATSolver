-- This is a SAT solver that uses the DPLL algorithm to solve SAT problems.
-- The program reads a file with a SAT problem in the DIMACS format and writes the solution to another file.
-- The program uses the DPLL algorithm implemented in the dpll function in the DPLL module.
import DPLL
import System.Environment

-- List of literals to a disjunctive normal form
literalsToDNF :: [String] -> DNF
literalsToDNF [] = F -- Empty list -> False formula
literalsToDNF (x:xs) = V x (literalsToDNF xs) -- Create a disjunctive normal form -> V means OR

-- List of lines to a conjunctive normal form
linesToCNF :: [String] -> CNF
linesToCNF [] = T -- Empty list -> True formula
linesToCNF (x:xs) = A (literalsToDNF $ init $ words x) (linesToCNF xs) -- Create a conjunctive normal form -> A means AND

-- Converts a string to a conjunctive normal form (reads the file and filters out comments and the problem line, 
-- then converts the rest to a CNF)
toCNF :: String -> CNF
toCNF fileText = linesToCNF $ filter (\line -> not $ elem (head $ words line) ["c", "p"]) $ lines fileText

-- Calls dpll after the conjunctive normal form is created from the string and returns the solution
solve :: String -> String
solve fileText 
        | ans = unwords val
        | otherwise = "UNSAT"
        where (ans, val) = dpll (toCNF fileText, [])

-- Reads a file and writes the solution to another file
-- main function
solveSAT :: String -> String -> IO ()
solveSAT inputFile outputFile = do
        fileText <- readFile inputFile
        let printOut = solve fileText
        writeFile outputFile printOut
        putStrLn $ "Solution: \n"++printOut