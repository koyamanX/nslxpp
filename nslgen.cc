#include "nslgen.hh"

NSLGen::NSLGen()
{

}

NSLGen::~NSLGen()
{

}

void NSLGen::gen(std::ostream &out, std::map<std::string, json> &modules)
{
    out << "NSLGen::gen" << std::endl;
    for(auto &module : modules)
    {
        out << "module: " << module.first << std::endl;
        out << "module: " << module.second.dump(4) << std::endl;
    }
}
