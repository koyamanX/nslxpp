#include "nslxpp.tab.hh"
#include "nslxpp.hh"
#include "nslxpp_scanner.hh" // Include the header file for NSLXPP_Scanner

NSLXPP::NSLXPP_Driver::~NSLXPP_Driver()
{

}

void NSLXPP::NSLXPP_Driver::parse(std::istream &in)
{
    NSLXPP_Scanner *scanner = nullptr;
    scanner = new NSLXPP_Scanner(&in);
    NSLXPP_Parser parser(*scanner, *this);
    parser.parse();
}