#ifndef __AST_H__
#define __AST_H__

#include <fstream>
#include <vector>
#include "SymbolTable.h"

class SymbolEntry;

class Node
{
private:
    static int counter;
    int seq;
    Node* next;
public:
    Node();
    int getSeq() const {return seq;};
    void setNext(Node* node);
    Node* getNext() { return next; }
    virtual void output(int level) = 0;
};

class ExprNode : public Node
{
public:
    SymbolEntry *symbolEntry;

    ExprNode(SymbolEntry *symbolEntry) : symbolEntry(symbolEntry){};
    virtual int getValue() { return 0; };
};

class BinaryExpr : public ExprNode
{
private:
    int op;
    ExprNode *expr1, *expr2;
public:
    enum {ADD, SUB, AND, OR, LESS, MORE, MOREEQUAL, LESSEQUAL, EQUAL, NOEQUAL, MUL, DIV, PERC};
    BinaryExpr(SymbolEntry *se, int op, ExprNode*expr1, ExprNode*expr2) : ExprNode(se), op(op), expr1(expr1), expr2(expr2){};
    void output(int level);
    void typeCheck();
    void genCode();
    int getValue();
};

class Constant : public ExprNode
{
public:
    Constant(SymbolEntry *se) : ExprNode(se){};
    void output(int level);
};

class Id : public ExprNode
{
public:
    Id(SymbolEntry *se) : ExprNode(se){};
    void output(int level);
    void change();
};

class ConstId : public ExprNode
{
public:
    ConstId(SymbolEntry *se) : ExprNode(se){};
    void output(int level);
    void change();
};

class FuncFParam : public ExprNode
{
public:
    FuncFParam(SymbolEntry *se) : ExprNode(se){};
    void output(int level);
};

class ListNode : public Node
{};


class StmtNode : public Node
{};

class Empty : public StmtNode
{
public:
    void output(int level);
};


class AssignStmt : public StmtNode
{
private:
    ExprNode *lval;
    ExprNode *expr;
public:
    AssignStmt(ExprNode *lval, ExprNode *expr) : lval(lval), expr(expr) {};
    void output(int level);
};

class BreakStmt : public StmtNode
{
public:
    BreakStmt() {};
    void output(int level);
}
;

class ContinueStmt : public StmtNode
{
public:
    ContinueStmt() {};
    void output(int level);
};

class CompoundStmt : public StmtNode
{
private:
    StmtNode *stmt;
public:
    CompoundStmt(StmtNode *stmt) : stmt(stmt) {};
    void output(int level);
};

class SeqNode : public StmtNode
{
private:
    StmtNode *stmt1, *stmt2;
public:
    SeqNode(StmtNode *stmt1, StmtNode *stmt2) : stmt1(stmt1), stmt2(stmt2){};
    void output(int level);
};

class ConstIdList : public ListNode
{
public:
    std::vector<ConstId*> CIds;
    std::vector<AssignStmt*> Assigns;
    ConstIdList(std::vector<ConstId*> CIds, std::vector<AssignStmt*> Assigns) : CIds(CIds), Assigns(Assigns) {};
    void output(int level);
};

class FuncRParams : public ListNode
{
public:
    std::vector<ExprNode*> Exprs;
    FuncRParams(std::vector<ExprNode*> Exprs) : Exprs(Exprs){};
    void output(int level);
};

class FuncFParams : public ListNode
{
public:
    std::vector<FuncFParam*> FPs;
    std::vector<AssignStmt*> Assigns;
    FuncFParams(std::vector<FuncFParam*> FPs, std::vector<AssignStmt*> Assigns) : FPs(FPs), Assigns(Assigns) {};
    void output(int level);
};

class SingleStmt : public StmtNode
{
private:
    ExprNode* expr;
public:
    SingleStmt(ExprNode* expr) : expr(expr){};
    void output(int level);
};

class SingleExpr : public ExprNode 
{
private:
    int op;
    ExprNode *expr;
public:
    enum {SUB, ADD, EXCLAMATION};
    SingleExpr(SymbolEntry *se, int op, ExprNode*expr) : ExprNode(se), op(op), expr(expr){};
    void output(int level);
};

class DeclStmt : public StmtNode {
   private:
    Id* id;
    ExprNode* expr;

   public:
    DeclStmt(Id* id, ExprNode* expr = nullptr) : id(id), expr(expr){};
    void output(int level);

    std::string getname();

    Id* getId() { return id; };
};

class ConstDeclStmt : public StmtNode {
   private:
    ConstId* id;
    ExprNode* expr;

   public:
    ConstDeclStmt(ConstId* id, ExprNode* expr = nullptr) : id(id), expr(expr){};
    void output(int level);

    std::string getname();

    ConstId* getId() { return id; };
};

class IfStmt : public StmtNode
{
private:
    ExprNode *cond;
    StmtNode *thenStmt;
public:
    IfStmt(ExprNode *cond, StmtNode *thenStmt) : cond(cond), thenStmt(thenStmt){};
    void output(int level);
};

class WhileStmt : public StmtNode
{
private:
    ExprNode *cond;
    StmtNode *loop;
public:
    WhileStmt(ExprNode *cond, StmtNode *loop) : cond(cond), loop(loop) {};
    void output(int level);
};

class IfElseStmt : public StmtNode
{
private:
    ExprNode *cond;
    StmtNode *thenStmt;
    StmtNode *elseStmt;
public:
    IfElseStmt(ExprNode *cond, StmtNode *thenStmt, StmtNode *elseStmt) : cond(cond), thenStmt(thenStmt), elseStmt(elseStmt) {};
    void output(int level);
};

class ReturnStmt : public StmtNode
{
private:
    ExprNode *retValue;
public:
    ReturnStmt(ExprNode*retValue) : retValue(retValue) {};
    void output(int level);
};



class FunctionDef : public StmtNode
{
private:
    SymbolEntry *se;
    FuncFParams *FPs;
    StmtNode *stmt;
public:
    FunctionDef(SymbolEntry *se, FuncFParams *FPs, StmtNode *stmt) : se(se), FPs(FPs), stmt(stmt){};
    void output(int level);
};


class FunctionCall : public ExprNode
{
public:
    FuncRParams *RPs;
    FunctionCall(SymbolEntry*se, FuncRParams *RPs) : ExprNode(se), RPs(RPs){};
    void output(int level);
};

class Ast
{
private:
    Node* root;
public:
    Ast() {root = nullptr;}
    void setRoot(Node*n) {root = n;}
    void output();
};

#endif