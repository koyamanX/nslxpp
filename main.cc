#include "nslxpp.tab.hh"
#include "nslxpp.hh"

int main(void) {
    NSLXPP::NSLXPP_Driver nslxpp;
    nslxpp.parse(std::cin);
    nslxpp.gen(std::cout);
    return 0;
}
