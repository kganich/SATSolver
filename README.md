
# Haskell SAT Solver using DPLL Algorithm

This Haskell project implements a SAT (Satisfiability) solver using the DPLL (Davis-Putnam-Logemann-Loveland) algorithm. The SAT solver is capable of reading SAT problems in DIMACS format, processing them using the DPLL algorithm, and outputting the result as either `SAT` (satisfiable) or `UNSAT` (unsatisfiable).

## What is a SAT Solver?

A SAT solver is a tool designed to solve Boolean satisfiability problems (SAT). The SAT problem is the problem of determining whether there exists an assignment of variables that satisfies a given Boolean formula expressed in Conjunctive Normal Form (CNF). If such an assignment exists, the formula is called satisfiable (`SAT`), otherwise, it is unsatisfiable (`UNSAT`).

### Conjunctive Normal Form (CNF)
A CNF is a conjunction of clauses, where each clause is a disjunction of literals. For example:
- Formula: (x1 ∨ ¬x2) ∧ (¬x1 ∨ x3)

### DPLL Algorithm

The DPLL algorithm is a backtracking-based search algorithm used to determine the satisfiability of a logical formula in CNF. It operates with the following main steps:
1. **Unit Propagation**: If a clause becomes a unit clause (contains only one literal), assign the necessary value to satisfy that clause.
2. **Pure Literal Elimination**: If a literal appears with only one polarity (either positive or negative) across all clauses, it can be assigned a truth value that satisfies all clauses where it appears.
3. **Backtracking**: Choose a literal, assign it a truth value, and recursively attempt to satisfy the remaining formula. If a conflict arises, backtrack and try the opposite value.

The algorithm repeats this process until either a satisfying assignment is found (`SAT`) or it is determined that no such assignment exists (`UNSAT`).

## Project Structure

This project consists of two main files:
1. **satsolver.hs**: The main file that handles input/output and prepares the SAT problem for solving.
2. **dpll.hs**: Implements the DPLL algorithm, which performs the satisfiability check on the provided CNF formula.

### Main Components

#### `satsolver.hs`
- **literalsToDNF**: Converts a list of literals into disjunctive normal form (DNF).
- **linesToCNF**: Converts a list of strings into a conjunctive normal form (CNF).
- **toCNF**: Reads a SAT problem file in DIMACS format and converts it into CNF.
- **solve**: Calls the `dpll` function and returns the result as either `SAT` or `UNSAT`.
- **solveSAT**: Handles reading from an input file, invoking the solver, and writing the result to an output file.

#### `dpll.hs`
- **dpll**: The main function implementing the DPLL algorithm. It recursively checks the formula for satisfiability by:
  - Performing unit propagation,
  - Handling pure literal assignments,
  - Recursively splitting on literals and attempting both assignments (true/false) until a solution is found or determined to be unsatisfiable.
- **simplify**: Simplifies the formula by removing clauses satisfied by a given literal and removing occurrences of the negated literal.
- **step**: Repeatedly performs unit propagation and pure literal elimination.
- **firstLiteral**: Selects the first literal from the formula for further processing.
- **elemL**: Checks if the formula contains an empty clause, which would indicate unsatisfiability.

## Prerequisites

- **GHC (Glasgow Haskell Compiler)**: Ensure you have GHC version 8.10 or above installed.
  
To install GHC, visit the [official GHC website](https://www.haskell.org/ghc/).

## How to Run

1. Clone the repository or download the code files (`satsolver.hs` and `dpll.hs`).
   
2. Compile the project using GHC:
   ```bash
   ghc -o satsolver satsolver.hs dpll.hs
   ```

3. Prepare your SAT problem in DIMACS format. An example format would look like:
   ```
   p cnf 3 3
   1 -2 0
   -1 3 0
   -3 0
   ```
   This corresponds to the formula: 
   \[
   (x_1 \lor 
eg x_2) \land (
eg x_1 \lor x_3) \land (
eg x_3)
   \]

4. Run the SAT solver by passing the input and output file paths:
   ```bash
   ./satsolver input.cnf output.txt
   ```

5. The result will be either `SAT` with the variable assignments or `UNSAT`.

## Example

Given an input file `input.cnf`:
```
p cnf 3 3
1 -2 0
-1 3 0
-3 0
```

Run the solver:
```bash
./satsolver input.cnf output.txt
```

If the problem is satisfiable, the output file will contain the satisfying assignment of variables:
```
SAT
1 -2 3
```
If unsatisfiable, it will contain:
```
UNSAT
```
