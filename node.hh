#ifndef NODE_HH
#define NODE_HH

#include <string>
#include <vector>

class ScopeNode;

typedef enum {
    ND_DECLARE,
    ND_MODULE,
    ND_INPUT,
    ND_OUTPUT,
    ND_ASSIGN,
    ND_NUMBER,
    ND_IDENTIFIER,
    ND_WIRE,
    ND_REG,
    ND_MEM,
    ND_EXPRESSION,
    ND_ELEMENT,
} NodeKind;

typedef enum {
    ND_ADD,
    ND_SUB,
    ND_MUL,
    ND_BITWISE_AND,
    ND_BITWISE_OR,
    ND_BITWISE_XOR,
    ND_BITWISE_NOT,
    ND_EQUAL,
    ND_NOT_EQUAL,
    ND_LESS,
    ND_LESS_EQUAL,
    ND_GREATER,
    ND_GREATER_EQUAL,
    ND_SHIFT_LEFT,
    ND_SHIFT_RIGHT,
    ND_CONDITIONAL,
    ND_LOGICAL_AND,
    ND_LOGICAL_OR,
    ND_LOGICAL_NOT,
    ND_REDUCTION_AND,
    ND_REDUCTION_OR,
    ND_REDUCTION_XOR,
    ND_REDUCTION_NOT,
    ND_NOT,
} NodeType;

typedef struct Node Node;
struct Node {
    NodeKind kind;
    NodeType type;
    ScopeNode *scope;
    std::vector<Node *> *common_tasks;
    Node *left;
    Node *right;
    size_t width;
    size_t depth;
    std::string name;
};

Node *new_node_declare(ScopeNode *scope);
Node *new_node_module(ScopeNode *scope, std::vector<Node *> *common_tasks);
Node *new_node_assign(Node *left, Node *right);
Node *new_node_identifier(NodeKind type, size_t width);
Node *new_node_wire(size_t width);
Node *new_node_wire(void);
Node *new_node_reg(size_t width);
Node *new_node_reg(void);
Node *new_node_mem(size_t width);
Node *new_node_mem(size_t width, size_t depth);
Node *new_node_lvalue(std::string name);
Node *new_node_input(size_t width);
Node *new_node_input();
Node *new_node_output(size_t width);
Node *new_node_output();
Node *new_node_expression(NodeType type, Node *left, Node *right);
Node *new_node_expression(NodeType type, Node *left);
Node *new_node_element(std::string name);

#endif // NODE_HH