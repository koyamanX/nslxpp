#ifndef NSLGEN_HH
#define NSLGEN_HH

#include "node.hh"

class NSLGen {
public:
    NSLGen(std::ostream& out);
    void gen(ScopeNode *global_scope);

private:
    std::ostream& out;
};

#endif