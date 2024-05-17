#include "scope.hh"

#include <iostream>

Scope::Scope()
{
    scope = new ScopeNode {};
    scope->parent = nullptr;
    global = scope;
}

Scope::~Scope()
{
    delete scope;
}

void Scope::enter()
{
    ScopeNode* new_scope = new ScopeNode {};
    new_scope->parent = scope;
    scope = new_scope;
}

void Scope::leave()
{
    if (scope->parent == nullptr) {
        std::cerr << "cannot leave top level scope" << std::endl;
        exit(EXIT_FAILURE);
    }
    scope = scope->parent;
}

void Scope::add_var(const std::string& name, Node* var)
{
    if (scope->vars.find(name) != scope->vars.end()) {
        std::cerr << "var " << name << " already exists" << std::endl;
        exit(EXIT_FAILURE);
    }
    scope->vars[name] = var;
}

Node* Scope::find_var(const std::string& name)
{
    ScopeNode* current = scope;
    while (current) {
        if (current->vars.find(name) != current->vars.end()) {
            return current->vars[name];
        }
        current = current->parent;
    }
    return nullptr;
}

void Scope::add_module(const std::string& name, Node* module)
{
    if (global->modules.find(name) != global->modules.end()) {
        std::cerr << "module " << name << " already exists" << std::endl;
        exit(EXIT_FAILURE);
    }
    global->modules[name] = module;
}

Node* Scope::find_module(const std::string& name)
{
    ScopeNode* current = global;
    while (current) {
        if (current->modules.find(name) != current->modules.end()) {
            return current->modules[name];
        }
        current = current->parent;
    }
    return nullptr;
}

void Scope::add_declare(const std::string& name, Node* declare)
{
    if (global->declares.find(name) != global->declares.end()) {
        std::cerr << "declare " << name << " already exists" << std::endl;
        exit(EXIT_FAILURE);
    }
    global->declares[name] = declare;
}

Node* Scope::find_declare(const std::string& name)
{
    ScopeNode* current = global;
    while (current) {
        if (current->declares.find(name) != current->declares.end()) {
            return current->declares[name];
        }
        current = current->parent;
    }
    return nullptr;
}

ScopeNode*
Scope::get_scope(void)
{
    return scope;
}
