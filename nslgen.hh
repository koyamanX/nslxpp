#ifndef NSLGEN_HH
#define NSLGEN_HH

#include "IGen.hh"

class NSLGen : public IGen {
public:
    NSLGen(std::ostream &out);
    virtual ~NSLGen();
    void gen(std::map<std::string, json> &modules);

private:
    void gen_declare(const std::string &name, json &signals);
    void gen_input(json &signal);
    void gen_output(json &signal);
    void gen_func_in(json &signal);
    void gen_func_out(json &signal);
    void gen_func_in_params(const std::vector<json> &params);
    void gen_func_in_return(const json &ret);
    void gen_func_out_params(const std::vector<json> &params);
    void gen_func_out_return(const json &ret);
    void gen_opening_brace();
    void gen_closing_brace();
    std::ostream &out;
    size_t indent = 0;
};

#endif