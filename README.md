# PostgreSQL Chess Extension

This is my course project for INFOH417 Database System Architecture 2023/24 at ULB. We designed a PostgreSQL extension for storing and
retrieving chess games. There exist multiple notations for encoding complete chess games as well as for encoding the board status at a certain move in the game. In particular, we used [Standard Algebraic Notation (SAN)](https://en.wikipedia.org/wiki/Algebraic_notation_(chess)) to store the moves part of the Portable Game Notation (PGN), and [Forsyth–Edwards Notation (FEN)](https://en.wikipedia.org/wiki/Forsyth%E2%80%93Edwards_Notation) to store board states.

## Description

The extension implements the following **datatypes**
- chessboard
- chessgame

The following **functions** have been implemented:
- `getBoard(chessgame, integer) -> chessboard`: Return the board state at a given half-move (A full move is counted only when both players have played). The integer parameter indicates the count of half moves since the beginning of the game. A 0 value of this parameter means the initial board state, i.e. (rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1).
- `getFirstMoves(chessgame, integer) -> chessgame`: Returns the chessgame truncated to its first N half-moves. The integer parameter is zero based.
- `hasOpening(chessgame, chessgame) -> bool`: Returns true if the first chess game starts with the exact same set of moves as the second chess game. The second parameter should not be a full game, but should only contain the opening moves that we want to check for, which can be of any length, i.e., m half-moves.
- `hasBoard(chessgame, chessboard, integer) -> bool`: Returns true if the chessgame contains the given board state in its first N half-moves.

The following **indices** have been implemented:
- `hasOpening_idx`: Supports the hasOpening predicate. The index is defined on the chessgame type. Uses a B-tree, since a chessgame can be seen as a string, with a total order property.
- `hasBoard_idx`: Supports the hasBoard predicate. Uses the GIN index as an expression index with `getAllStates(chessgame)`. The reason is that a chessgame can also be seen as a sequence of chessboard states. GIN would allow for indexing the individual states per chessgame.

## Installation

Ensure you have installed PostgreSQL in a Linux environment (Ubuntu, WSL, etc). Then do,

`make && make install`

Next, open a `psql` session and create the extension via `CREATE EXTENSION chess`. The `tests` folder contains many examples of interacting with the extension.
