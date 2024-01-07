#include "nslgen.hh"

NSLGen::NSLGen(std::ostream &out) : out(out)
{

}

NSLGen::~NSLGen()
{

}

void NSLGen::gen(std::map<std::string, json> &modules)
{
    out << "NSLGen::gen" << std::endl;
    for(auto &module : modules)
    {
        out << "module: " << module.first << std::endl;
        out << "module: " << module.second.dump(4) << std::endl;
    }
}
