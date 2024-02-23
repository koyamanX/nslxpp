#ifndef NSLGEN_HH
#define NSLGEN_HH

#include "IGen.hh"
#include "node.hh"

class NSLGen : public IGen {
public:
    NSLGen(std::ostream& out);
    void gen(std::map<std::string, Node*>& modules);

private:
    std::ostream& out;
};

#endif