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

#ifndef YY_YY_INCLUDE_PARSER_H_INCLUDED
# define YY_YY_INCLUDE_PARSER_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif
/* "%code requires" blocks.  */
#line 10 "src/parser.y"

    #include "Ast.h"
    #include "SymbolTable.h"
    #include "Type.h"

#line 54 "include/parser.h"

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    ID = 258,
    INTEGER = 259,
    FLOAT_NUM = 260,
    IF = 261,
    ELSE = 262,
    BREAK = 263,
    CONTINUE = 264,
    WHILE = 265,
    INT = 266,
    VOID = 267,
    CHAR = 268,
    FLOAT = 269,
    CONST = 270,
    LPAREN = 271,
    RPAREN = 272,
    LBRACE = 273,
    RBRACE = 274,
    LSBRACE = 275,
    RSBRACE = 276,
    SEMICOLON = 277,
    COMMA = 278,
    ADD = 279,
    SUB = 280,
    MUL = 281,
    DIV = 282,
    EXCLAMATION = 283,
    MORE = 284,
    OR = 285,
    AND = 286,
    LESS = 287,
    ASSIGN = 288,
    EQUAL = 289,
    NOEQUAL = 290,
    LESSEQUAL = 291,
    MOREEQUAL = 292,
    PERC = 293,
    RETURN = 294,
    LINECOMMENT = 295,
    COMMENTBEIGN = 296,
    COMMENTELEMENT = 297,
    COMMENTLINE = 298,
    COMMENTEND = 299,
    THEN = 300
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 16 "src/parser.y"

    int itype;
    char* strtype;
    float floattype;
    StmtNode* stmttype;
    ExprNode* exprtype;
    DeclStmt* decl;
    ConstDeclStmt* cdecl;
    Type* type;
    FuncFParams* Fstype;
    FuncRParams* FRtype;

#line 124 "include/parser.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_INCLUDE_PARSER_H_INCLUDED  */
