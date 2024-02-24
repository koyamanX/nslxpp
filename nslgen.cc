#include "nslgen.hh"

#include "nslxx.hh"

NSLGen::NSLGen(std::ostream& out)
    : out(out)
{
}

static void gen_io_list(ScopeNode *scope)
{
    for (auto& var : scope->vars) {
        if (var.second->kind == ND_INPUT) {
            std::cout << "    input " << var.first << ": " << "UINT<" << var.second->width << ">" << std::endl;
        } else if (var.second->kind == ND_OUTPUT) {
            std::cout << "    output " << var.first << ": " << "UINT<" << var.second->width << ">" << std::endl;
        }
    }
}

static void gen_clock_and_reset(void)
{
    std::cout << "    input m_clock: Clock" << std::endl;
    std::cout << "    input p_reset: AsyncReset" << std::endl;
}

static void gen_variables(ScopeNode *scope)
{
    for (auto& var : scope->vars) {
        if (var.second->kind == ND_WIRE) {
            std::cout << "    wire " << var.first << ": " << "UINT<" << var.second->width << ">" << std::endl;
        }
    }
}

static void merge_scope(ScopeNode *dst, ScopeNode *src)
{
    for (auto& var : src->vars) {
        if (dst->vars.find(var.first) != dst->vars.end()) {
            std::cout << "var " << var.first << " already exists" << std::endl;
            exit(EXIT_FAILURE);
        }
        dst->vars[var.first] = var.second;
    }
}

static void gen_module(std::string name, Node *module, Node *declare)
{
    std::cout << "cuircit " << name << ":" << std::endl;
    std::cout << "  module " << name << ":" << std::endl;
    gen_clock_and_reset();
    merge_scope(module->scope, declare->scope);
    gen_io_list(module->scope);
    gen_variables(module->scope);

}

void NSLGen::gen(ScopeNode *global_scope)
{
    for (auto& module : global_scope->modules) {
        auto declare = global_scope->declares.find(module.first);
        if (declare == global_scope->declares.end()) {
            std::cout << "module " << module.first << " has no declare" << std::endl;
            exit(EXIT_FAILURE);
        }
        gen_module(module.first, module.second, declare->second);
    }
}
