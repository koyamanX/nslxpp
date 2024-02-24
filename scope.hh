#ifndef SCOPE_HH
#define SCOPE_HH

#include <map>
#include <string>

#include "node.hh"

typedef struct ScopeNode ScopeNode;
struct ScopeNode {
    ScopeNode* parent;
    // TODO: use a union for vars, modules, and declares
    std::map<std::string, Node*> vars;
    std::map<std::string, Node*> modules;
    std::map<std::string, Node*> declares;
};

class Scope {
public:
    Scope();
    ~Scope();
    void enter();
    void leave();
    void add_var(const std::string& name, Node* var);
    Node* find_var(const std::string& name);
    void add_module(const std::string& name, Node* module);
    Node* find_module(const std::string& name);
    void add_declare(const std::string& name, Node* declare);
    Node* find_declare(const std::string& name);
    ScopeNode* get_scope();

private:
    ScopeNode* scope;
};

#endif // SCOPE_HH