#ifndef NSLXX_HH
#define NSLXX_HH

#include <iostream>
#include <map>
#include <memory>
#include <string>
#include "scope.hh"
#include "nslgen.hh"

namespace NSLXX {
class NSLXX_Driver {
public:
    NSLXX_Driver(NSLGen* gen);
    virtual ~NSLXX_Driver();
    void gen(ScopeNode *global_scope);
    void parse(std::istream& in = std::cin);
    Scope scope;

private:
    NSLGen* codegenerator;
}; // class NSLXX_Driver
} // namespace NSLXX

#endif
