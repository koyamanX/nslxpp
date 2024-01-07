#include "nslgen.hh"
#include "nslxpp.hh"

NSLGen::NSLGen(std::ostream &out) : out(out)
{

}

NSLGen::~NSLGen()
{

}

void NSLGen::gen_declare(const std::string &name, const std::map<std::string, json> &symtab) {
    out << "declare " << name;
    gen_opening_brace();
    for(auto &i : symtab)
    {
        auto &signal = i.second;
        switch(signal["type"].get<NSLXPP::NodeType>())
        {
            case NSLXPP::ND_INPUT:
                gen_input(signal.get<json>());
                break;
            case NSLXPP::ND_OUTPUT:
                gen_output(signal.get<json>());
                break;
            case NSLXPP::ND_FUNC_IN:
                gen_func_in(signal.get<json>());
                break;
            case NSLXPP::ND_FUNC_OUT:
                gen_func_out(signal.get<json>());
                break;
        }
    }
    gen_closing_brace();
}

void NSLGen::gen_input(const json &signal) {
    out << "input " << signal["name"].get<std::string>() << "[" << signal["size"].get<size_t>() << "];" << std::endl;
}

void NSLGen::gen_output(const json &signal) {
    out << "output " << signal["name"].get<std::string>() << "[" << signal["size"].get<size_t>() << "];" << std::endl;
}

void NSLGen::gen_func_in(const json &signal) {
    out << "func_in " << signal["name"].get<std::string>() << "(";
    if(signal.contains("params")) {
        gen_func_in_params(signal["params"].get<std::vector<json>>());
    }
    out << ")";
    if(signal.contains("return")) {
        gen_func_in_return(signal["return"].get<json>());
    }
    out << ";" << std::endl;
}

void NSLGen::gen_func_in_params(const std::vector<json> &params) {
    if(params.size() > 0)
    {
        for(auto &param : params)
        {
            out << param.get<std::string>();
            if(param != params.back())
            {
                out << ", ";
            }
        }
    }
}

void NSLGen::gen_func_in_return(const json &ret) {
    out << " : ";
    out << ret.get<std::string>();
}

void NSLGen::gen_func_out(const json &signal) {
    out << "func_out " << signal["name"].get<std::string>() << "(";
    if(signal.contains("params")) {
        gen_func_out_params(signal["params"].get<std::vector<json>>());
    }
    out << ")";
    if(signal.contains("return")) {
        gen_func_out_return(signal["return"].get<json>());
    }
    out << ";" << std::endl;
}

void NSLGen::gen_func_out_params(const std::vector<json> &params) {
    if(params.size() > 0)
    {
        for(auto &param : params)
        {
            out << param.get<std::string>();
            if(param != params.back())
            {
                out << ", ";
            }
        }
    }
}

void NSLGen::gen_func_out_return(const json &ret) {
    out << " : ";
    out << ret.get<std::string>();
}

void NSLGen::gen(std::map<std::string, json> &modules)
{
    for(auto &module : modules)
    {
        auto &name = module.first;
        auto symtab = module.second["signals"].get<std::map<std::string, json>>();
        gen_declare(name, symtab);
    
    }
}

void NSLGen::gen_opening_brace()
{
    out << " {" << std::endl;
    indent++;
}

void NSLGen::gen_closing_brace()
{
    out << "}" << std::endl;
    indent--;
}