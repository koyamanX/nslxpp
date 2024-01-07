#include "nslxpp.tab.hh"
#include "nslxpp.hh"
#include "nslxpp_scanner.hh" // Include the header file for NSLXPP_Scanner

NSLXPP::NSLXPP_Driver::~NSLXPP_Driver()
{

}

void NSLXPP::NSLXPP_Driver::parse(std::istream &in)
{
    NSLXPP_Scanner *scanner = nullptr;
    scanner = new NSLXPP_Scanner(&in);
    NSLXPP_Parser parser(*scanner, *this);
    parser.parse();
}

void NSLXPP::NSLXPP_Driver::add_module(const std::string &name, json &module)
{
    if(modules.find(name) != modules.end())
    {
        std::cerr << "Error: Module " << name << " already exists" << std::endl;
        exit(1);
    }
    modules.emplace(name, module);
}

void NSLXPP::NSLXPP_Driver::add_declare(const std::string &name, json &module)
{
    if(declares.find(name) != declares.end())
    {
        std::cerr << "Error: Declare " << name << " already exists" << std::endl;
        std::cout << "declares: " << declares << std::endl;
        exit(1);
    }
    declares.emplace(name, module);
}

json NSLXPP::NSLXPP_Driver::find_module(const std::string &name)
{
    auto it = modules.find(name);
    if(it != modules.end())
    {
        return it->second;
    }
    else
    {
        return nullptr;
    }
}

json NSLXPP::NSLXPP_Driver::find_declare(const std::string &name)
{
    auto it = declares.find(name);
    if(it != declares.end())
    {
        return it->second;
    }
    else
    {
        return nullptr;
    }
}

void NSLXPP::NSLXPP_Driver::gen(std::ostream &out)
{
    for(auto &it : declares)
    {
        auto &declare = it.second;

        if(declare["type"] != ND_DECLARE)
        {
            continue;
        }

        out << "declare " << declare["name"].get<std::string>() << " {" << std::endl;

        for(auto &io : declare["io"])
        {
            if(io["type"] == ND_INPUT)
            {
                out << "    input " << io["name"].get<std::string>() << "[" << io["size"] << "];" << std::endl;
            }
            else if(io["type"] == ND_OUTPUT)
            {
                out << "    output " << io["name"].get<std::string>() << "[" << io["size"] << "];" << std::endl;
            } else if(io["type"] == ND_FUNC_IN)
            {
                out << "    func_in " << io["name"].get<std::string>() << "(";
                
                out << ");" << std::endl;
            } else if(io["type"] == ND_FUNC_OUT)
            {
                out << "    func_out " << io["name"].get<std::string>() << "[" << io["size"] << "];" << std::endl;
            }
        }
        out << "}" << std::endl;
    }
}