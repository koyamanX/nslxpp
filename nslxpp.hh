#ifndef NSLXPP_HH
#define NSLXPP_HH

#include <iostream>

namespace NSLXPP {
class NSLXPP {
public:
    NSLXPP() = default;
    virtual ~NSLXPP();

    void parse(std::istream &in);
};
}

#endif