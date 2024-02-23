#ifndef SCOPE_HH
#define SCOPE_HH

#include <map>
#include <string>
#include "node.hh"

typedef struct ScopeNode ScopeNode;
struct ScopeNode {
    ScopeNode *parent;
    std::map<std::string, Node*> vars;
    std::map<std::string, Node*> modules;
    std::map<std::string, Node*> declares;
};

class Scope {
public:
    Scope() {

    }
    ~Scope() {
        delete scope;
    }
    void enter(void) {
        std::cout << "entering scope" << std::endl;
        ScopeNode *new_scope = new ScopeNode{};
        new_scope->parent = scope;
        scope = new_scope;
    }
    void leave(void) {
        std::cout << "leaving scope" << std::endl;
        ScopeNode *old_scope = scope;
        scope = scope->parent;
        delete old_scope;
    }
    void add_var(const std::string &name, Node* var) {
        if (scope->vars.find(name) != scope->vars.end()) {
            std::cout << "var " << name << " already exists" << std::endl;
            exit(EXIT_FAILURE);
        }
        std::cout << "adding var " << name << std::endl;
        scope->vars[name] = var;
    }
    Node* find_var(const std::string &name) {
        ScopeNode *current = scope;
        while (current) {
            if (current->vars.find(name) != current->vars.end()) {
                return current->vars[name];
            }
            current = current->parent;
        }
        return nullptr;
    }
    void add_module(const std::string &name, Node* module) {
        if (scope->modules.find(name) != scope->modules.end()) {
            std::cout << "module " << name << " already exists" << std::endl;
            exit(EXIT_FAILURE);
        }
        std::cout << "adding module " << name << std::endl;
        scope->modules[name] = module;
    }
    Node* find_module(const std::string &name) {
        ScopeNode *current = scope;
        while (current) {
            if (current->modules.find(name) != current->modules.end()) {
                return current->modules[name];
            }
            current = current->parent;
        }
        return nullptr;
    }
    void add_declare(const std::string &name, Node* declare) {
        if (scope->declares.find(name) != scope->declares.end()) {
            std::cout << "declare " << name << " already exists" << std::endl;
            exit(EXIT_FAILURE);
        }
        std::cout << "adding declare " << name << std::endl;
        scope->declares[name] = declare;
    }
    Node* find_declare(const std::string &name) {
        ScopeNode *current = scope;
        while (current) {
            if (current->declares.find(name) != current->declares.end()) {
                return current->declares[name];
            }
            current = current->parent;
        }
        return nullptr;
    }
    ScopeNode *get_scope(void) {
        return scope;
    }
private:
    ScopeNode *scope = new ScopeNode{};
};

#endif // SCOPE_HH