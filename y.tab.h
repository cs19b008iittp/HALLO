/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    START = 258,
    END = 259,
    ASSIGNMENT = 260,
    NUMBERCONST = 261,
    FLOATCONST = 262,
    CONTAINER = 263,
    MATRIX = 264,
    ARITHMETIC = 265,
    RELATIONAL = 266,
    LOGICAL = 267,
    COMMA = 268,
    FULLSTOP = 269,
    ID = 270,
    TYPE = 271,
    COLON = 272,
    BY = 273,
    REPEAT = 274,
    FROM = 275,
    TO = 276,
    DONE = 277,
    NOTE = 278,
    SEND = 279,
    CALL = 280,
    DIGIT = 281,
    IF = 282,
    OTHERWISE = 283,
    THEN = 284,
    AND = 285,
    OR = 286,
    LE = 287,
    GE = 288,
    EQ = 289,
    NE = 290,
    LT = 291,
    GT = 292,
    UMINUS = 293
  };
#endif
/* Tokens.  */
#define START 258
#define END 259
#define ASSIGNMENT 260
#define NUMBERCONST 261
#define FLOATCONST 262
#define CONTAINER 263
#define MATRIX 264
#define ARITHMETIC 265
#define RELATIONAL 266
#define LOGICAL 267
#define COMMA 268
#define FULLSTOP 269
#define ID 270
#define TYPE 271
#define COLON 272
#define BY 273
#define REPEAT 274
#define FROM 275
#define TO 276
#define DONE 277
#define NOTE 278
#define SEND 279
#define CALL 280
#define DIGIT 281
#define IF 282
#define OTHERWISE 283
#define THEN 284
#define AND 285
#define OR 286
#define LE 287
#define GE 288
#define EQ 289
#define NE 290
#define LT 291
#define GT 292
#define UMINUS 293

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
