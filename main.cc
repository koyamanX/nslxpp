#include "nslxpp.tab.hh"
#include "nslxpp_scanner.hh" 

int main(void) {
    NSLXPP::NSLXPP_Scanner *scanner = nullptr;
    scanner = new NSLXPP::NSLXPP_Scanner();
    NSLXPP::NSLXPP_Parser parser(*scanner);
    parser.parse();
    return 0;
}
