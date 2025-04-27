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
            std::cout << "    input " << var.first << ": " << "UInt<" << var.second->width << ">" << std::endl;
        } else if (var.second->kind == ND_OUTPUT) {
            std::cout << "    output " << var.first << ": " << "UInt<" << var.second->width << ">" << std::endl;
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
            std::cout << "    wire " << var.first << ": " << "UInt<" << var.second->width << ">" << std::endl;
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

static void gen_simulation(Node *node)
{
	std::cout << "    wire halt: UInt<1>" << std::endl;
	std::cout << "    halt <= UInt(1)" << std::endl;
	std::cout << "    printf(m_clock, halt, \"" << node->str << "\")" << std::endl;
	std::cout << "    stop(m_clock, halt, 0)" << std::endl;

}

static void gen_module(std::string name, Node *module, Node *declare)
{
    std::cout << "circuit " << name << ":" << std::endl;
    std::cout << "  module " << name << ":" << std::endl;
    gen_clock_and_reset();
    //merge_scope(module->scope, declare->scope);
    gen_io_list(module->scope);
    gen_variables(module->scope);

	for(auto& task : module->common_tasks) {
		switch(task->kind) {
			case ND_SIM_FINISH:
				gen_simulation(task);
				break;
		}
	}
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
