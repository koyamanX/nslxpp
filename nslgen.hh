#ifndef NSLGEN_HH
#define NSLGEN_HH

#include "IGen.hh"

class NSLGen : public IGen {
public:
    NSLGen();
    virtual ~NSLGen();
    void gen(std::ostream &out = std::cout);
};

#endif