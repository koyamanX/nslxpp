#ifndef NSLXX_HH
#define NSLXX_HH

#include <iostream>
#include <map>
#include <memory>
#include <string>

#include "IGen.hh"
#include "scope.hh"

namespace NSLXX {
class NSLXX_Driver {
public:
    NSLXX_Driver(IGen* gen);
    virtual ~NSLXX_Driver();
    void gen(std::ostream& out = std::cout);
    void parse(std::istream& in = std::cin);
    Scope scope;

private:
    IGen* codegenerator;
}; // class NSLXX_Driver
} // namespace NSLXX

#endif
