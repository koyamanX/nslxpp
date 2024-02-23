#ifndef IGEN_HH
#define IGEN_HH

#include <iostream>
#include <map>
#include <string>
#include "node.hh"

class IGen {
 public:
  virtual ~IGen(){};
  virtual void gen(std::map<std::string, Node *> &modules) = 0;
};

#endif