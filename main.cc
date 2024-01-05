#include "nslxpp.tab.hh"
#include "nslxpp.hh"

int main(void) {
    NSLXPP::NSLXPP nslxpp;
    nslxpp.parse(std::cin);
    return 0;
}
