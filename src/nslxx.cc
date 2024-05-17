#include "nslxx.hh"

#include <memory>

#include "nslxx.tab.hh"
#include "nslxx_scanner.hh"
#include "nslgen.hh"

NSLXX::NSLXX_Driver::NSLXX_Driver(NSLGen* gen)
{
    codegenerator = gen;
}

NSLXX::NSLXX_Driver::~NSLXX_Driver() { }

void NSLXX::NSLXX_Driver::parse(std::istream& in)
{
    NSLXX_Scanner* scanner = nullptr;
    scanner = new NSLXX_Scanner(&in);
    NSLXX_Parser parser(*scanner, *this);
    parser.parse();
}

void NSLXX::NSLXX_Driver::gen(ScopeNode *global_scope)
{
    codegenerator->gen(global_scope);
}
