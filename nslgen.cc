#include "nslgen.hh"
#include "nslxpp.hh"

NSLGen::NSLGen(std::ostream &out) : out(out)
{

}

NSLGen::~NSLGen()
{

}

void NSLGen::gen_declare(const std::string &name, json &signals) {
    out << "declare " << name;
    gen_opening_brace();
    for(auto &signal : signals)
    {
        if(signal["type"] == NSLXPP::ND_INPUT)
        {
            gen_input(signal);
        }
        else if(signal["type"] == NSLXPP::ND_OUTPUT)
        {
            gen_output(signal);
        }
        else if(signal["type"] == NSLXPP::ND_FUNC_IN)
        {
            gen_func_in(signal);
        }
        else if(signal["type"] == NSLXPP::ND_FUNC_OUT)
        {
            gen_func_out(signal);
        }
    }
    gen_closing_brace();
}

void NSLGen::gen_input(json &signal) {
    out << "input " << signal["name"].get<std::string>() << "[" << signal["size"] << "];" << std::endl;
}

void NSLGen::gen_output(json &signal) {
    out << "output " << signal["name"].get<std::string>() << "[" << signal["size"] << "];" << std::endl;
}

void NSLGen::gen_func_in(json &signal) {
    out << "func_in " << signal["name"].get<std::string>() << "(";
    gen_func_in_params(signal["params"]);
    out << ")";
    gen_func_in_return(signal["return"]);
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
    if(!ret.is_null())
    {
        out << " : ";
        out << ret.get<std::string>();
    }
}

void NSLGen::gen_func_out(json &signal) {
    out << "func_out " << signal["name"].get<std::string>() << "(";
    gen_func_out_params(signal["params"]);
    out << ")";
    gen_func_out_return(signal["return"]);
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
    if(!ret.is_null())
    {
        out << " : ";
        out << ret.get<std::string>();
    }
}

void NSLGen::gen(std::map<std::string, json> &modules)
{
    for(auto &module : modules)
    {
        gen_declare(module.first, module.second["signals"]);
    
    }
}

void NSLGen::gen_opening_brace()
{
    out << " {" << std::endl;
    indent++;
    out.width(indent * 4);
}

void NSLGen::gen_closing_brace()
{
    out << "}" << std::endl;
    indent--;
    out.width(indent * 4);
}