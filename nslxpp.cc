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

void NSLXPP::NSLXPP_Driver::set_current_module(const std::string &name)
{
    current_module_name = name;
    current_module = find_declare(name);
    
    if(current_module == nullptr)
    {
        std::cerr << "Error: Module " << name << " not found" << std::endl;
        exit(1);
    }
}

json NSLXPP::NSLXPP_Driver::get_current_module()
{
    return current_module;
}