#include "nslgen.hh"
#include "nslxx.hh"
#include "nslxx.tab.hh"

int main(void)
{
    NSLXX::NSLXX_Driver nslxx(new NSLGen(std::cout));
    nslxx.parse(std::cin);
    nslxx.gen();
    return 0;
}
