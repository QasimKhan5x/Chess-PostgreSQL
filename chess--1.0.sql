-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION chess" to load this file. \quit

/************************************************************************************************************
                                          Chessboard to represent FEN
************************************************************************************************************/

/******************************************************************************
 * Input/Output
 ******************************************************************************/

CREATE OR REPLACE FUNCTION chessboard_in(cstring)
    RETURNS chessboard
    AS 'MODULE_PATHNAME'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION chessboard_out(chessboard)
    RETURNS cstring
    AS 'MODULE_PATHNAME'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION chessboard_recv(internal)
   RETURNS chessboard
   AS 'MODULE_PATHNAME'
   LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION chessboard_send(chessboard)
   RETURNS bytea
   AS 'MODULE_PATHNAME'
   LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

/******************************************************************************
 * Create the datatype
 ******************************************************************************/

CREATE TYPE chessboard (
  internallength = -1,
  input          = chessboard_in,
  output         = chessboard_out,
  receive        = chessboard_recv,
  send           = chessboard_send
);

/******************************************************************************
 * Constructor
 ******************************************************************************/

CREATE OR REPLACE FUNCTION chessboard(fen text)
  RETURNS chessboard
  AS 'MODULE_PATHNAME', 'chessboard_constructor'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;


/******************************************************************************
 * Operators
 ******************************************************************************/

CREATE FUNCTION chessboard_eq(chessboard, chessboard)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'chessboard_eq'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION chessboard_neq(chessboard, chessboard)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'chessboard_neq'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION chessboard_lt(chessboard, chessboard)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'chessboard_lt'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION chessboard_le(chessboard, chessboard)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'chessboard_le'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION chessboard_gt(chessboard, chessboard)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'chessboard_gt'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION chessboard_ge(chessboard, chessboard)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'chessboard_ge'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR = (
  LEFTARG = chessboard, RIGHTARG = chessboard,
  PROCEDURE = chessboard_eq,
  COMMUTATOR = =, NEGATOR = <>
);

CREATE OPERATOR <> (
  LEFTARG = chessboard, RIGHTARG = chessboard,
  PROCEDURE = chessboard_neq,
  COMMUTATOR = <>, NEGATOR = =
);

CREATE OPERATOR < (
  LEFTARG = chessboard, RIGHTARG = chessboard,
  PROCEDURE = chessboard_lt
);

CREATE OPERATOR <= (
  LEFTARG = chessboard, RIGHTARG = chessboard,
  PROCEDURE = chessboard_le
);

CREATE OPERATOR > (
  LEFTARG = chessboard, RIGHTARG = chessboard,
  PROCEDURE = chessboard_gt
);

CREATE OPERATOR >= (
  LEFTARG = chessboard, RIGHTARG = chessboard,
  PROCEDURE = chessboard_ge
);