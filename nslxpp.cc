#include "nslxpp.hh"

#include <memory>

#include "nslxpp.tab.hh"
#include "nslxpp_scanner.hh"

NSLXPP::NSLXPP_Driver::NSLXPP_Driver(IGen *gen) { codegenerator = gen; }

NSLXPP::NSLXPP_Driver::~NSLXPP_Driver() {}

void NSLXPP::NSLXPP_Driver::parse(std::istream &in) {
  NSLXPP_Scanner *scanner = nullptr;
  scanner = new NSLXPP_Scanner(&in);
  NSLXPP_Parser parser(*scanner, *this);
  parser.parse();
}

void NSLXPP::NSLXPP_Driver::gen(std::ostream &out) {
  //codegenerator->gen(modules);
}
