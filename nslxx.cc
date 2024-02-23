#include "nslxx.hh"

#include <memory>

#include "nslxx.tab.hh"
#include "nslxx_scanner.hh"

NSLXX::NSLXX_Driver::NSLXX_Driver(IGen *gen) { codegenerator = gen; }

NSLXX::NSLXX_Driver::~NSLXX_Driver() {}

void NSLXX::NSLXX_Driver::parse(std::istream &in) {
  NSLXX_Scanner *scanner = nullptr;
  scanner = new NSLXX_Scanner(&in);
  NSLXX_Parser parser(*scanner, *this);
  parser.parse();
}

void NSLXX::NSLXX_Driver::gen(std::ostream &out) {
  //codegenerator->gen(modules);
}
