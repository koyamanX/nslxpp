#include "nslgen.hh"
#include "nslxx.hh"
#include "nslxx.tab.hh"

int main(int argc, char **argv)
{
    if(argc > 1)
    {
	std::ifstream file(argv[1]);
	if(file.is_open())
	{
	    NSLXX::NSLXX_Driver nslxx(new NSLGen(std::cout));
	    nslxx.parse(file);
	    nslxx.gen(nslxx.scope.get_scope());
	    return 0;
	}
	else
	{
	    std::cerr << "Error: Could not open file " << argv[1] << std::endl;
	    return 1;
	}
    }

    return 0;
}
