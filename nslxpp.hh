#ifndef NSLXPP_HH
#define NSLXPP_HH

#include <iostream>
#include <map>
#include <memory>
#include <string>
#include "scope.hh"

#include "IGen.hh"

namespace NSLXPP {
class NSLXPP_Driver {
 public:
  NSLXPP_Driver(IGen *gen);
  virtual ~NSLXPP_Driver();
  void gen(std::ostream &out = std::cout);
  void parse(std::istream &in = std::cin);

  Scope scope;
private:

  IGen *codegenerator;
};

}  // namespace NSLXPP

#endif
