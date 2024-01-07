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

void NSLXPP::NSLXPP_Driver::add_module(const std::string &name, json &module) {
  if (modules.find(name) != modules.end()) {
    std::cerr << "Error: Module " << name << " already exists" << std::endl;
    exit(1);
  }
  modules.emplace(name, module);
}

void NSLXPP::NSLXPP_Driver::add_declare(const std::string &name, json &module) {
  if (declares.find(name) != declares.end()) {
    std::cerr << "Error: Declare " << name << " already exists" << std::endl;
    std::cout << "declares: " << declares << std::endl;
    exit(1);
  }
  declares.emplace(name, module);
}

json NSLXPP::NSLXPP_Driver::find_module(const std::string &name) {
  auto it = modules.find(name);
  if (it != modules.end()) {
    return it->second;
  } else {
    return nullptr;
  }
}

json NSLXPP::NSLXPP_Driver::find_declare(const std::string &name) {
  auto it = declares.find(name);
  if (it != declares.end()) {
    return it->second;
  } else {
    return nullptr;
  }
}

json NSLXPP::NSLXPP_Driver::take_declare(const std::string &name) {
  auto it = declares.find(name);
  if (it != declares.end()) {
    json ret = it->second;
    declares.erase(it);
    return ret;
  } else {
    return nullptr;
  }
}

void NSLXPP::NSLXPP_Driver::gen(std::ostream &out) {
  codegenerator->gen(modules);
}
