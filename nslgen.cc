#include "nslgen.hh"

#include "nslxpp.hh"

NSLGen::NSLGen(std::ostream &out) : out(out) {}

NSLGen::~NSLGen() {}

void NSLGen::gen_declare(const std::string &name,
                         const std::map<std::string, json> &symtab) {
  out << "declare " << name;
  gen_opening_brace();
  for (auto &i : symtab) {
    auto &signal = i.second;
    auto signal_type = signal["type"].get<NSLXPP::NodeType>();
    auto signal_node = signal.get<json>();

    switch (signal_type) {
      case NSLXPP::ND_INPUT:
        gen_input(signal_node);
        break;
      case NSLXPP::ND_OUTPUT:
        gen_output(signal_node);
        break;
      case NSLXPP::ND_FUNC_IN:
        gen_func_in(signal_node, symtab);
        break;
      case NSLXPP::ND_FUNC_OUT:
        gen_func_out(signal_node, symtab);
        break;
    }
  }
  gen_closing_brace();
}

void NSLGen::gen_input(const json &signal) {
  auto signal_name = signal["name"].get<std::string>();
  auto signal_size = signal["size"].get<size_t>();

  out << "input " << signal_name << "[" << signal_size << "];" << std::endl;
}

void NSLGen::gen_output(const json &signal) {
  auto signal_name = signal["name"].get<std::string>();
  auto signal_size = signal["size"].get<size_t>();

  out << "output " << signal_name << "[" << signal_size << "];" << std::endl;
}

void NSLGen::gen_func_in(const json &signal,
                         const std::map<std::string, json> &symtab) {
  auto signal_name = signal["name"].get<std::string>();

  out << "func_in " << signal_name << "(";
  if (signal.contains("params")) {
    auto params_node = signal["params"].get<std::vector<json>>();

    gen_func_in_params(params_node, symtab);
  }
  out << ")";
  if (signal.contains("return")) {
    auto return_node = signal["return"].get<json>();

    gen_func_in_return(return_node, symtab);
  }
  out << ";" << std::endl;
}

void NSLGen::gen_func_in_params(const std::vector<json> &params,
                                const std::map<std::string, json> &symtab) {
  if (params.size() > 0) {
    for (auto &param : params) {
      auto param_name = param.get<std::string>();
      auto symbol = symtab.find(param_name);

      if (symbol == symtab.end()) {
        out << "ERROR: " << param_name << " is not a signal" << std::endl;
        exit(1);
      }
      auto symbol_type = symbol->second["type"].get<NSLXPP::NodeType>();

      if (symbol_type != NSLXPP::ND_INPUT) {
        out << "ERROR: " << param_name << " is not an input signal"
            << std::endl;
        exit(1);
      }

      out << param_name;
      if (param != params.back()) {
        out << ", ";
      }
    }
  }
}

void NSLGen::gen_func_in_return(const json &ret,
                                const std::map<std::string, json> &symtab) {
  auto return_name = ret.get<std::string>();
  auto symbol = symtab.find(return_name);

  if (symbol == symtab.end()) {
    out << "ERROR: " << return_name << " is not a signal" << std::endl;
    exit(1);
  }
  auto symbol_type = symbol->second["type"].get<NSLXPP::NodeType>();

  if (symbol_type != NSLXPP::ND_OUTPUT) {
    out << "ERROR: " << return_name << " is not an output signal" << std::endl;
    exit(1);
  }

  out << " : ";
  out << return_name;
}

void NSLGen::gen_func_out(const json &signal,
                          const std::map<std::string, json> &symtab) {
  auto signal_name = signal["name"].get<std::string>();

  out << "func_out " << signal_name << "(";
  if (signal.contains("params")) {
    auto params_node = signal["params"].get<std::vector<json>>();

    gen_func_out_params(params_node, symtab);
  }
  out << ")";
  if (signal.contains("return")) {
    auto return_node = signal["return"].get<json>();

    gen_func_out_return(return_node, symtab);
  }
  out << ";" << std::endl;
}

void NSLGen::gen_func_out_params(const std::vector<json> &params,
                                 const std::map<std::string, json> &symtab) {
  if (params.size() > 0) {
    for (auto &param : params) {
      auto param_name = param.get<std::string>();
      auto symbol = symtab.find(param_name);

      if (symbol == symtab.end()) {
        out << "ERROR: " << param_name << " is not a signal" << std::endl;
        exit(1);
      }
      auto symbol_type = symbol->second["type"].get<NSLXPP::NodeType>();

      if (symbol_type != NSLXPP::ND_OUTPUT) {
        out << "ERROR: " << param_name << " is not an output signal"
            << std::endl;
        exit(1);
      }

      out << param_name;
      if (param != params.back()) {
        out << ", ";
      }
    }
  }
}

void NSLGen::gen_func_out_return(const json &ret,
                                 const std::map<std::string, json> &symtab) {
  auto return_name = ret.get<std::string>();
  auto symbol = symtab.find(return_name);

  if (symbol == symtab.end()) {
    out << "ERROR: " << return_name << " is not a signal" << std::endl;
    exit(1);
  }
  auto symbol_type = symbol->second["type"].get<NSLXPP::NodeType>();

  if (symbol_type != NSLXPP::ND_INPUT) {
    out << "ERROR: " << return_name << " is not an input signal" << std::endl;
    exit(1);
  }

  out << " : ";
  out << return_name;
}

void NSLGen::gen(std::map<std::string, json> &modules) {
  for (auto &module : modules) {
    auto &name = module.first;
    auto symtab = module.second["signals"].get<std::map<std::string, json>>();

    gen_declare(name, symtab);
  }
}

void NSLGen::gen_opening_brace() {
  out << " {" << std::endl;
  indent++;
}

void NSLGen::gen_closing_brace() {
  out << "}" << std::endl;
  indent--;
}