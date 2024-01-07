#ifndef IGEN_HH
#define IGEN_HH

#include <iostream>
#include <string>
#include <map>
#include <nlohmann/json.hpp>

using json = nlohmann::json;

class IGen {
public:
    virtual ~IGen() {};
    virtual void gen(std::map<std::string, json> &modules) = 0;
};

#endif