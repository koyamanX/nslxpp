#include "nslxpp.tab.hh"
#include "nslxpp.hh"
#include "nslgen.hh"

int main(void) {
    NSLXPP::NSLXPP_Driver nslxpp(new NSLGen());
    nslxpp.parse(std::cin);
    nslxpp.gen(std::cout);
    return 0;
}
