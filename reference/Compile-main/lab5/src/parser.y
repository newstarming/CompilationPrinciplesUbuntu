%code top{
    #include <iostream>
    #include <assert.h>
    #include "parser.h"
    extern Ast ast;
    int yylex();
    int yyerror( char const * );
}

%code requires {
    #include "Ast.h"
    #include "SymbolTable.h"
    #include "Type.h"
}

%union {
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
}

%start Program
%token <strtype> ID 
%token <itype> INTEGER
%token <floattype> FLOAT_NUM
%token IF ELSE BREAK CONTINUE
%token WHILE
%token INT VOID CHAR FLOAT 
%token CONST 
%token LPAREN RPAREN LBRACE RBRACE LSBRACE RSBRACE SEMICOLON COMMA
%token ADD SUB MUL DIV EXCLAMATION MORE OR AND LESS ASSIGN EQUAL NOEQUAL LESSEQUAL MOREEQUAL PERC
%token RETURN
%token LINECOMMENT COMMENTBEIGN COMMENTELEMENT COMMENTLINE COMMENTEND

%nterm <stmttype> Stmts Stmt AssignStmt BlockStmt IfStmt ReturnStmt DeclStmt FuncDef WhileStmt VarDeclStmt ConstDeclStmt  SingleStmt
%nterm <exprtype> Exp ConstInitvalue AddExp MulExp Cond LOrExp PrimaryExp LVal RelExp LAndExp Initvalue UnaryExp 
%nterm <type> Type
%nterm <decl> VarDefList VarDef 
%nterm <cdecl> ConstDefList ConstDef
%nterm <Fstype> FuncFParams
%nterm <FRtype> FuncRParams

%precedence THEN
%precedence ELSE
%%

Program
    : Stmts {
        ast.setRoot($1);
    }
    ;
Stmts
    : Stmt {$$=$1;}
    | Stmts Stmt{
        $$ = new SeqNode($1, $2);
    }
    ;
Stmt
    : AssignStmt {$$=$1;}
    | BlockStmt {$$=$1;}
    | IfStmt {$$=$1;}
    | ReturnStmt {$$=$1;}
    | DeclStmt {$$=$1;}
    | FuncDef {$$=$1;}
    | WhileStmt {$$ = $1;}
    | SEMICOLON {$$ = new Empty();}
    | BREAK SEMICOLON {$$ = new BreakStmt();}
    | CONTINUE SEMICOLON {$$ = new ContinueStmt();}
    | SingleStmt {$$ = $1;}
    ;

AssignStmt
    : LVal ASSIGN Exp SEMICOLON {
        $$ = new AssignStmt($1, $3);
    }
    ;

LVal
    : ID {
        SymbolEntry *se;
        se = identifiers->lookup($1);
        if(se == nullptr) {
            //using undef var
            fprintf(stderr, "identifier \"%s\" is undefined\n", (char*)$1);
            delete [](char*)$1;
            assert(se != nullptr);
        }
        $$ = new Id(se);
        //return the id to calc
        delete []$1;
    }
    ;

Exp
    :
    AddExp {$$ = $1;}
    ;


AddExp
    :
    MulExp {$$ = $1;}
    | AddExp ADD MulExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::ADD, $1, $3);
        
    }
    | AddExp SUB MulExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::SUB, $1, $3);
        //to protect the priority of (+/-  */\)
    }
    ;

MulExp
    :
    UnaryExp {$$ = $1;}
    | MulExp MUL UnaryExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::MUL, $1, $3);
    }
    | MulExp DIV UnaryExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::DIV, $1, $3);
    }
    | MulExp PERC UnaryExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::PERC, $1, $3);
        //we use the binary exp to get the calc(by the way of tree)
    }
    ;    

SingleStmt
    :
    Exp SEMICOLON{
        $$ = new SingleStmt($1);
    }
    ;

UnaryExp
    :
    PrimaryExp {$$ = $1;}
    |
    ID LPAREN RPAREN{
        SymbolEntry *se;
        se = identifiers->lookup($1);
        if(se == nullptr)
        {
            fprintf(stderr, "Function \"%s\" is undefined\n", (char*)$1);
            delete [](char*)$1;
            assert(se != nullptr);
        }
        $$ = new FunctionCall(se, nullptr);
        delete []$1;
    }
    |
    ID LPAREN FuncRParams RPAREN{
        SymbolEntry *se;
        se = identifiers->lookup($1);
        if(se == nullptr)
        {
            fprintf(stderr, "Function \"%s\" is undefined\n", (char*)$1);
            delete [](char*)$1;
            assert(se != nullptr);
        }
        $$ = new FunctionCall(se, $3);
        delete []$1;
    }
    |
    SUB UnaryExp {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new SingleExpr(se, SingleExpr::SUB, $2);
    }
    |
    EXCLAMATION UnaryExp{
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new SingleExpr(se, SingleExpr::EXCLAMATION, $2);
    }
    |
    ADD UnaryExp{
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new SingleExpr(se, SingleExpr::ADD, $2);
    }
    ;

PrimaryExp
    :
    LVal {
        $$ = $1;
    } | INTEGER {
        SymbolEntry *se = new ConstantSymbolEntry(TypeSystem::intType, $1);
        $$ = new Constant(se);
    } | FLOAT_NUM {
        SymbolEntry *se = new FloatConstantSymbolEntry(TypeSystem::floatType, $1);
        $$ = new Constant(se);
    } | LPAREN Exp RPAREN{$$ = $2;}
    ;

BlockStmt
    :   LBRACE 
        {
            identifiers = new SymbolTable(identifiers);
            // we new a symbol table to use new var
        } 
        Stmts RBRACE 
        {
            $$ = new CompoundStmt($3);
            SymbolTable *top = identifiers;
            identifiers = identifiers->getPrev();
            delete top;
            // free the new table 
        }
    ;

IfStmt
    : IF LPAREN Cond RPAREN Stmt %prec THEN {
        $$ = new IfStmt($3, $5);
    }| IF LPAREN Cond RPAREN LBRACE RBRACE {
        $$ = new IfStmt($3, new Empty());
    }| IF LPAREN Cond RPAREN Stmt ELSE Stmt {
        $$ = new IfElseStmt($3, $5, $7);
    }
    ;

WhileStmt
    : WHILE LPAREN Cond RPAREN Stmt {
        $$ = new WhileStmt($3, $5);
    }
    ;

ReturnStmt
    :
    RETURN Exp SEMICOLON{
        $$ = new ReturnStmt($2);
    }
    ;

Cond
    :
    LOrExp {$$ = $1;}
    ;

LOrExp
    : 
    LAndExp {$$ = $1;}
    | LOrExp OR LAndExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::OR, $1, $3);
        //use the binary to get the exp of bool
    }
    ;

LAndExp
    :
    RelExp {$$ = $1;}
    | LAndExp AND RelExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::AND, $1, $3);
    }
    ;

RelExp
    :
    AddExp {$$ = $1;}
    | RelExp LESS AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::LESS, $1, $3);
    }
    | RelExp MORE AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::MORE, $1, $3);
    }
    | RelExp MOREEQUAL AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::MOREEQUAL, $1, $3);
    }
    | RelExp LESSEQUAL AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::LESSEQUAL, $1, $3);
    }
    | RelExp EQUAL AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::EQUAL, $1, $3);
    }
    | RelExp NOEQUAL AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::NOEQUAL, $1, $3);
        //the relexp, Landexp, Lorexp are set to achieve the request of priority and asscociativity
    }
    ;

Type
    : INT {
        $$ = TypeSystem::intType;
    } | VOID {
        $$ = TypeSystem::voidType;
    } | CHAR {
        $$ = TypeSystem::charType;
    } | FLOAT {
        $$ = TypeSystem::floatType;
    }
    ;

DeclStmt
    : VarDeclStmt {$$ = $1;}
    | ConstDeclStmt {$$ = $1;}
    ;

VarDeclStmt
    : Type VarDefList SEMICOLON {
        $$ = $2;
        //if we want to think the type(int/float) , we must exchange the mode
        if ($1 != TypeSystem::intType) {
            SymbolEntry* se;
            se = new IdentifierSymbolEntry(TypeSystem::floatType, $2->getname(), identifiers->getLevel());
            identifiers->install($2->getname(), se);
            $2->getId()->change();
            DeclStmt *now = $2;
            while (now->getNext() != nullptr) {
                now = dynamic_cast<DeclStmt*>(now->getNext());
                SymbolEntry* se;
                se = new IdentifierSymbolEntry(TypeSystem::floatType, now->getname(), identifiers->getLevel());
                identifiers->install(now->getname(), se);
                now->getId()->change();
            }
        }
    }
    ;

ConstDeclStmt
    : CONST Type ConstDefList SEMICOLON {
        $$ = $3;
         if ($2 != TypeSystem::intType) {
            SymbolEntry* se;
            se = new IdentifierSymbolEntry(TypeSystem::floatType, $3->getname(), identifiers->getLevel());
            identifiers->install($3->getname(), se);
            $3->getId()->change();
            ConstDeclStmt *now = $3;
            while (now->getNext() != nullptr) {
                now = dynamic_cast<ConstDeclStmt*>(now->getNext());
                SymbolEntry* se;
                se = new IdentifierSymbolEntry(TypeSystem::floatType, now->getname(), identifiers->getLevel());
                identifiers->install(now->getname(), se);
                now->getId()->change();
            }
        }
    }
    ;

ConstDefList
    : ConstDefList COMMA ConstDef {
        $$ = $1;
        $1->setNext($3);
    }
    | ConstDef {$$ = $1;}
    ;

VarDefList
    : VarDefList COMMA VarDef {
        $$ = $1;
        $1->setNext($3);
        //build up the chain of exp
    } | VarDef {
        $$ = $1;
    }
    ;

VarDef
    : ID {
        SymbolEntry* se;
        se = new IdentifierSymbolEntry(TypeSystem::intType, $1, identifiers->getLevel());
        identifiers->install($1, se);
        $$ = new DeclStmt(new Id(se));
        delete []$1;
    } | ID ASSIGN Initvalue {
        SymbolEntry* se;
        se = new IdentifierSymbolEntry(TypeSystem::intType, $1, identifiers->getLevel());
        identifiers->install($1, se);
        //if the type is float, we must change the type in the proc of decl
        ((IdentifierSymbolEntry*)se)->setValue($3->getValue());
        $$ = new DeclStmt(new Id(se), $3);
        delete []$1;
    }
    ;

ConstDef
    : ID ASSIGN ConstInitvalue {
        SymbolEntry* se;
        se = new IdentifierSymbolEntry(TypeSystem::intType, $1, identifiers->getLevel());
        // error
        identifiers->install($1, se);
        ((IdentifierSymbolEntry*)se)->setValue($3->getValue());
        $$ = new ConstDeclStmt(new ConstId(se), $3);
        delete []$1;
    }

Initvalue
    : Exp {
        $$ = $1;
        //we must add the code about the array in here
    }
    ;

ConstInitvalue
    : Exp {
        $$ = $1;
        //we must add the code about the array in here
    }

FuncDef
    :
    Type ID LPAREN {
        Type *funcType;
        funcType = new FunctionType($1,{});
        SymbolEntry *se = new IdentifierSymbolEntry(funcType, $2, identifiers->getLevel());
        identifiers->install($2, se);
        identifiers = new SymbolTable(identifiers);
    }
    RPAREN
    BlockStmt
    {
        SymbolEntry *se;
        se = identifiers->lookup($2);
        assert(se != nullptr);
        $$ = new FunctionDef(se, nullptr,$6);
        SymbolTable *top = identifiers;
        identifiers = identifiers->getPrev();
        delete top;
        delete []$2;
    }
    |
    Type ID LPAREN {
        Type *funcType;
        funcType = new FunctionType($1,{});
        SymbolEntry *se = new IdentifierSymbolEntry(funcType, $2, identifiers->getLevel());
        identifiers->install($2, se);
        identifiers = new SymbolTable(identifiers);
    }
    FuncFParams RPAREN
    BlockStmt
    {
        SymbolEntry *se;
        se = identifiers->lookup($2);
        assert(se != nullptr);
        $$ = new FunctionDef(se, $5 ,$7);
        SymbolTable *top = identifiers;
        identifiers = identifiers->getPrev();
        delete top;
        delete []$2;
    }
    ;

FuncRParams
    :
    Exp
    {
        std::vector<ExprNode*> t;
        t.push_back($1);
        FuncRParams *temp = new FuncRParams(t);
        $$ = temp;
    }
    |
    FuncRParams COMMA Exp
    {
        FuncRParams *temp = $1;
        temp -> Exprs.push_back($3);
        $$ = temp;
    }
    ;

FuncFParams
    :
    Type ID
    {
        std::vector<FuncFParam*> FPs;
        std::vector<AssignStmt*> Assigns;
        FuncFParams *temp = new FuncFParams(FPs, Assigns);
        SymbolEntry *se;
        se = new IdentifierSymbolEntry($1, $2, identifiers->getLevel());
        identifiers->install($2, se);
        temp -> FPs.push_back(new FuncFParam(se));
        $$ = temp;
        delete []$2;
    }
    |
    FuncFParams COMMA Type ID
    {
        FuncFParams *temp = $1;
        SymbolEntry *se;
        se = new IdentifierSymbolEntry($3, $4, identifiers->getLevel());
        identifiers->install($4, se);
        temp -> FPs.push_back(new FuncFParam(se));
        $$ = temp;
        delete []$4;
    }
    |
    Type ID ASSIGN Exp
    {
        std::vector<FuncFParam*> FPs;
        std::vector<AssignStmt*> Assigns;
        FuncFParams *temp = new FuncFParams(FPs, Assigns);
        SymbolEntry *se;
        se = new IdentifierSymbolEntry($1, $2, identifiers->getLevel());
        identifiers->install($2, se);
        FuncFParam* t = new FuncFParam(se);
        temp -> FPs.push_back(t);
        temp -> Assigns.push_back(new AssignStmt(t, $4));
        $$ = temp;
        delete []$2;
    }
    |
    FuncFParams COMMA Type ID ASSIGN Exp
    {
        FuncFParams *temp = $1;
        SymbolEntry *se;
        se = new IdentifierSymbolEntry($3, $4, identifiers->getLevel());
        identifiers->install($4, se);
        FuncFParam* t = new FuncFParam(se);
        temp -> FPs.push_back(t);
        temp -> Assigns.push_back(new AssignStmt(t, $6));
        $$ = temp;
        delete []$4;
    }
    ;


%%

int yyerror(char const* message)
{
    std::cerr<<message<<std::endl;
    return -1;
}

