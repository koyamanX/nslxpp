#include "nslgen.hh"

#include "nslxx.hh"

NSLGen::NSLGen(std::ostream& out)
    : out(out)
{
}

void NSLGen::gen(ScopeNode *global_scope)
{
    // dump declare and module name
    for (auto& declare : global_scope->declares) {
        out << "declare " << declare.first << std::endl;
    }
    for (auto& module : global_scope->modules) {
        out << "module " << module.first << std::endl;
    }
}
