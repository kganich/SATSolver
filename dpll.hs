-- In this file, I implemented the DPLL algorithm for solving the SAT problem.
-- The algorithm is implemented in the dpll function, which takes a formula in the conjunctive normal form and 
-- a list of values of variables (at the beginning is empty) and returns a pair (Bool, [String]), where the first element is True if the 
-- formula is satisfiable and False otherwise, and the second element is a list of values of variables that satisfy the formula.
-- The algorithm uses the step function to simplify the formula by removing unit clauses and pure literals.
module DPLL where
import qualified Data.Set as Set

-- the conjunctive normal form and disjunctive normal form
data CNF = T | A DNF CNF deriving Show
data DNF = F | V String DNF deriving Show

-- check if the literal l is in the disjunctive clause
dnfHasL :: String -> DNF -> Bool
dnfHasL l F = False
dnfHasL l (V h rest) = if h == l then True else dnfHasL l rest

-- simplifyDNF removes the literal l from the disjunctive normal form
simplifyDNF :: String -> DNF -> DNF
simplifyDNF l F = F
simplifyDNF l (V h rest) = if h==l then simplifyDNF l rest else V h (simplifyDNF l rest)

-- change the sign of the literal
neg :: String -> String
neg ('-':l) = l
neg l = '-':l

-- simplify simplifies the formula by removing the literal l from the formula
simplify :: String -> CNF -> CNF
simplify l T = T
simplify l (A h rest) = if l `dnfHasL` h then simplify l rest else A (simplifyDNF (neg l) h) (simplify l rest)

-- findUnit finds unit clauses in the formula
findUnit :: CNF -> [String]
findUnit T = []
findUnit (A (V l F) rest) = [l]  
findUnit (A h rest) = findUnit rest    

-- fromDNF returns a list of all literals in the disjunctive normal form
fromDNF :: DNF -> [String]
fromDNF F = []
fromDNF (V l rest) = l : fromDNF rest   

-- allL returns a list of all literals in the formula
allL :: CNF -> [String]
allL T = []
allL (A h rest) = fromDNF h ++ allL rest           

-- findPure finds pure literals in the list of literals that appear in the formula with one sign
findPure :: [String] -> [String]
findPure [] = []
findPure (('-':w):rest) = if (w `elem` rest) 
                then findPure (filter (\x -> not (x == w)) rest)
                else [('-':w)]
findPure (h:rest) = [h]

-- findPureLiteral finds pure literals in the formula
findPureLiteral :: CNF -> [String]
findPureLiteral formula = findPure (Set.toAscList (Set.fromList (allL formula))) -- sort the list of all literals and find pure literals

-- step simplifies the formula by removing unit clauses and pure literals
step :: (CNF, [String]) -> (CNF, [String])
step (formula, val) = let foundUnit = findUnit formula -- find unit clauses
                in case foundUnit of
                        [ ] -> let foundPureL = findPureLiteral formula -- if no unit clauses, find pure literals
                                in  case foundPureL of 
                                        [] -> (formula, val) -- if no pure literals, return the formula
                                        [l]  -> step (simplify l formula, l:val) -- if there is a pure literal, simplify the formula and add the literal to the list of values
                        [l]  -> step (simplify l formula, l:val) -- if there is a unit clause, simplify the formula and add the literal to the list of values

-- firstLiteral returns the first literal in the formula
firstLiteral :: CNF -> String
firstLiteral (A (V l _) _) = l

-- elemL returns True if there is a disjunctive clause with no literals
elemL :: CNF -> Bool
elemL T = False
elemL (A F rest) = True
elemL (A _ rest) = elemL rest

-- function DPLL(Φ)
-- // unit propagation:
-- while there is a unit clause {l} in Φ do
--     Φ ← unit-propagate(l, Φ);
-- // pure literal elimination:
-- while there is a literal l that occurs pure in Φ do
--     Φ ← pure-literal-assign(l, Φ);
-- // stopping conditions:
-- if Φ is empty then
--     return true;
-- if Φ contains an empty clause then
--     return false;
-- // DPLL procedure:
-- l ← choose-literal(Φ);
-- return DPLL(Φ ∧ {l}) or DPLL(Φ ∧ {¬l});
dpll :: (CNF, [String]) -> (Bool, [String])
dpll (phi, val) = case (step (phi, val)) of -- repeat until no more unit clauses or pure literals
        (T, satval) -> (True, satval)  -- if phi is empty, return True
        (phir, valr) -> if elemL phir then (False, []) -- if there is a clause with no literals, return False
                        else let l = firstLiteral phir  -- else choose a literal l from phir
                        in case (dpll (A (V l F) phir, valr)) of
                                (True, sat) -> (True, sat) -- if dpll(phir, valr) is true, return True
                                (False, _) -> dpll (A (V (neg l) F) phir, valr) -- if dpll(phir, valr) is false, return dpll(-l, valr)
