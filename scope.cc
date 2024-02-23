#include "scope.hh"

#include <iostream>

Scope::Scope()
{
    scope = new ScopeNode {};
    scope->parent = nullptr;
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
        std::cout << "cannot leave top level scope" << std::endl;
        exit(EXIT_FAILURE);
    }
    ScopeNode* old_scope = scope;
    scope = scope->parent;
    delete old_scope;
}

void Scope::add_var(const std::string& name, Node* var)
{
    if (scope->vars.find(name) != scope->vars.end()) {
        std::cout << "var " << name << " already exists" << std::endl;
        exit(EXIT_FAILURE);
    }
    std::cout << "adding var " << name << std::endl;
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
    if (scope->modules.find(name) != scope->modules.end()) {
        std::cout << "module " << name << " already exists" << std::endl;
        exit(EXIT_FAILURE);
    }
    std::cout << "adding module " << name << std::endl;
    scope->modules[name] = module;
}

Node* Scope::find_module(const std::string& name)
{
    ScopeNode* current = scope;
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
    if (scope->declares.find(name) != scope->declares.end()) {
        std::cout << "declare " << name << " already exists" << std::endl;
        exit(EXIT_FAILURE);
    }
    std::cout << "adding declare " << name << std::endl;
    scope->declares[name] = declare;
}

Node* Scope::find_declare(const std::string& name)
{
    ScopeNode* current = scope;
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
