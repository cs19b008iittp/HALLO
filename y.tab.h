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
    STRCONST = 265,
    ARITHMETIC = 266,
    RELATIONAL = 267,
    LOGICAL = 268,
    COMMA = 269,
    FULLSTOP = 270,
    ID = 271,
    TYPE = 272,
    COLON = 273,
    BY = 274,
    REPEAT = 275,
    FROM = 276,
    TO = 277,
    DONE = 278,
    NOTE = 279,
    SEND = 280,
    CALL = 281,
    ADD = 282,
    DELETE = 283,
    REMOVE = 284,
    IN = 285,
    OF = 286,
    SIZE = 287,
    CHANGE = 288,
    ROWSIZE = 289,
    COLUMNSIZE = 290,
    DIGIT = 291,
    IF = 292,
    OTHERWISE = 293,
    THEN = 294,
    DISPLAY = 295,
    GET = 296,
    LEAVE = 297,
    AND = 298,
    OR = 299,
    LE = 300,
    GE = 301,
    EQ = 302,
    NE = 303,
    LT = 304,
    GT = 305,
    UMINUS = 306
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
#define STRCONST 265
#define ARITHMETIC 266
#define RELATIONAL 267
#define LOGICAL 268
#define COMMA 269
#define FULLSTOP 270
#define ID 271
#define TYPE 272
#define COLON 273
#define BY 274
#define REPEAT 275
#define FROM 276
#define TO 277
#define DONE 278
#define NOTE 279
#define SEND 280
#define CALL 281
#define ADD 282
#define DELETE 283
#define REMOVE 284
#define IN 285
#define OF 286
#define SIZE 287
#define CHANGE 288
#define ROWSIZE 289
#define COLUMNSIZE 290
#define DIGIT 291
#define IF 292
#define OTHERWISE 293
#define THEN 294
#define DISPLAY 295
#define GET 296
#define LEAVE 297
#define AND 298
#define OR 299
#define LE 300
#define GE 301
#define EQ 302
#define NE 303
#define LT 304
#define GT 305
#define UMINUS 306

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
