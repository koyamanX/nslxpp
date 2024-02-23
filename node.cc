#include "node.hh"

Node *new_node_declare(ScopeNode *scope) {
    Node* node = new Node{};
    node->kind = ND_DECLARE;
    node->scope = scope;
    return node;
}

Node *new_node_module(ScopeNode *scope, std::vector<Node *> *common_tasks) {
    Node* node = new Node{};
    node->kind = ND_MODULE;
    node->scope = scope;
    node->common_tasks = common_tasks;
    return node;
}

Node *new_node_assign(Node *left, Node *right) {
    Node* node = new Node{};
    node->kind = ND_ASSIGN;
    node->left = left;
    node->right = right;
    return node;
}

Node *new_node_identifier(NodeKind kind, size_t width) {
    Node* node = new Node{};
    node->kind = kind;
    node->width = width;
    return node;
}

Node *new_node_wire(size_t width) {
    Node* node = new Node{};
    node->kind = ND_WIRE;
    node->width = width;
    return node;
}

Node *new_node_wire(void) {
    return new_node_wire(1);
}

Node *new_node_reg(size_t width) {
    Node* node = new Node{};
    node->kind = ND_REG;
    node->width = width;
    return node;
}

Node *new_node_reg(void) {
    return new_node_reg(1);
}

Node *new_node_mem(size_t width) {
    Node* node = new Node{};
    node->kind = ND_MEM;
    node->width = width;
    return node;
}

Node *new_node_mem(size_t width, size_t depth) {
    Node* node = new Node{};
    node->kind = ND_MEM;
    node->width = width;
    node->depth = depth;
    return node;
}

Node *new_node_lvalue(std::string name) {
    Node* node = new Node{};
    node->kind = ND_IDENTIFIER;
    node->name = name;
    return node;
}

Node *new_node_input(size_t width) {
    Node* node = new Node{};
    node->kind = ND_INPUT;
    node->width = width;
    return node;
}

Node *new_node_input() {
    return new_node_input(1);
}

Node *new_node_output(size_t width) {
    Node* node = new Node{};
    node->kind = ND_OUTPUT;
    node->width = width;
    return node;
}

Node *new_node_output() {
    return new_node_output(1);
}

Node *new_node_expression(NodeType type, Node *left, Node *right) {
    Node* node = new Node{};
    node->kind = ND_EXPRESSION;
    node->type = type;
    node->left = left;
    node->right = right;
    return node;
}

Node *new_node_expression(NodeType type, Node *left) {
    Node* node = new Node{};
    node->kind = ND_EXPRESSION;
    node->type = type;
    node->left = left;
    return node;
}

Node *new_node_element(std::string name) {
    Node* node = new Node{};
    node->kind = ND_ELEMENT;
    node->name = name;
    return node;
}