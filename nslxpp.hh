#ifndef NSLXPP_HH
#define NSLXPP_HH

#include <iostream>
#include <string>
#include <map>
#include <nlohmann/json.hpp>

using json = nlohmann::json;

namespace NSLXPP {
class NSLXPP_Driver {
public:
    NSLXPP_Driver()
    {
        current_module_name = "";
        current_module = nullptr;
    };
    virtual ~NSLXPP_Driver();
    void add_module(const std::string &name, json &module);
    void add_declare(const std::string &name, json &module);
    json find_declare(const std::string &name);
    json find_module(const std::string &name);
    void set_current_module(const std::string &name);
    json get_current_module();

    void parse(std::istream &in);
private:
    std::map<std::string, json> modules;
    std::map<std::string, json> declares;
    std::string current_module_name;
    json current_module;
};

enum {
	ND_DECLARE,
	ND_MODULE,
	ND_INPUT,
	ND_OUTPUT,
	ND_ASSIGN,
	ND_NUMBER,
	ND_IDENTIFIER,
	ND_ADD,
	ND_SUB,
	ND_MUL,
	ND_BITWISE_AND,
	ND_BITWISE_OR,
	ND_BITWISE_XOR,
	ND_BITWISE_NOT,
	ND_EQUAL,
	ND_NOT_EQUAL,
	ND_LESS,
	ND_LESS_EQUAL,
	ND_GREATER,
	ND_GREATER_EQUAL,
	ND_SHIFT_LEFT,
	ND_SHIFT_RIGHT,
	ND_CONDITIONAL,
	ND_LOGICAL_AND,
	ND_LOGICAL_OR,
	ND_LOGICAL_NOT,
	ND_ELEMENT,
	ND_EXPRESSION,
	ND_REDUCTION_AND,
	ND_REDUCTION_OR,
	ND_REDUCTION_XOR,
	ND_REDUCTION_NOT,
    ND_FUNC_IN,
    ND_FUNC_OUT,

};
}

#endif