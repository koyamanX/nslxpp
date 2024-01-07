#ifndef IGEN_HH
#define IGEN_HH

#include <iostream>
#include <map>
#include <nlohmann/json.hpp>
#include <string>

using json = nlohmann::json;

class IGen {
 public:
  virtual ~IGen(){};
  virtual void gen(std::map<std::string, json> &modules) = 0;
};

#endif