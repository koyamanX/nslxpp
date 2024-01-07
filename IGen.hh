#ifndef IGEN_HH
#define IGEN_HH

#include <iostream>

class IGen {
public:
    virtual ~IGen() {};
    virtual void gen(std::ostream &out = std::cout) = 0;
};

#endif