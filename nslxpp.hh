#ifndef NSLXPP_HH
#define NSLXPP_HH

#include <iostream>

namespace NSLXPP {
class NSLXPP_Driver {
public:
    NSLXPP_Driver() = default;
    virtual ~NSLXPP_Driver();

    void parse(std::istream &in);
};
}

#endif