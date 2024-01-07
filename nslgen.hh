#ifndef NSLGEN_HH
#define NSLGEN_HH

#include "IGen.hh"

class NSLGen : public IGen {
public:
    NSLGen(std::ostream &out);
    virtual ~NSLGen();
    void gen(std::map<std::string, json> &modules);

private:
    std::ostream &out;
};

#endif