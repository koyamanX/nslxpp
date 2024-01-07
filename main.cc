#include "nslgen.hh"
#include "nslxpp.hh"
#include "nslxpp.tab.hh"

int main(void) {
  NSLXPP::NSLXPP_Driver nslxpp(new NSLGen(std::cout));
  nslxpp.parse(std::cin);
  nslxpp.gen();
  return 0;
}
