%skeleton "lalr1.cc"
%require "3.0"
%defines
%define api.value.type variant
//%define api.token.constructor
%define api.namespace {NSLXPP}
%define api.parser.class {NSLXPP_Parser}
%locations

%code requires {
#include <string>
#include <vector>
#include <map>
#include <iostream>
#include <fstream>
#include <sstream>
#include <nlohmann/json.hpp>
#include "nslxpp.hh"
namespace NSLXPP {
	class NSLXPP_Parser;
	class NSLXPP_Scanner;
}
using json = nlohmann::json;
}

%parse-param { NSLXPP_Scanner& scanner }
%parse-param { NSLXPP_Driver &nslxpp }

%code {
#include "nslxpp_scanner.hh"

#undef yylex
#define yylex scanner.yylex
}

%token DECLARE MODULE STRUCT
%token INPUT OUTPUT INOUT
%token ASSIGN
%token<int> NUMBER
%token<std::string> IDENTIFIER

%type <json> module_declaration
%type <std::string> module_name
%type <json> io_declarations
%type <json> io_declaration
%type <json> input_declaration
%type <json> output_declaration
%type <std::string> input_name
%type <std::string> output_name

%type <json> module_definition
%type <std::vector<json>> common_tasks
%type <json> common_task
%type <json> lvalue
%type <json> expression
%type <json> conditional_expression
%type <json> logical_or_expression
%type <json> logical_and_expression
%type <json> relational_expression
%type <json> equalitiy_expression
%type <json> shift_expression
%type <json> additive_expression
%type <json> multiplicative_expression
%type <json> bitwise_or_expression
%type <json> bitwise_xor_expression
%type <json> bitwise_and_expression
%type <json> unary_expression
%type <json> element

%%
top:
	init nsls
	;
init:
	{}
nsls:
	nsls nsl
	|
	;
nsl:
	module_declaration {
		std::cout << $1.dump(4) << std::endl;
	}
	| module_definition {
		std::cout << $1.dump(4) << std::endl;
	}
	;
module_declaration:
	DECLARE module_name '{' io_declarations '}' {
		json ast = {
			{"type", ND_DECLARE},
			{"name", $2},
			{"io", $4}
		};
		$$ = move(ast);
	}
	;
module_definition:
	MODULE module_name '{' common_tasks '}' {
		json ast = {
			{"type", ND_MODULE},
			{"name", $2},
			{"common_tasks", $4}
		};
		$$ = move(ast);
	}
	;
module_name:
	IDENTIFIER
	;
common_tasks:
	common_tasks common_task {
		$1.push_back($2);
		$$ = move($1);
	}
	| {} /* empty */
	;
common_task:
	lvalue '=' expression ';' {
		json ast = {
			{"type", ND_ASSIGN},
			{"lvalue", $1},
			{"expression", $3}
		};
		$$ = move(ast);
	}
	;
lvalue:
	// TODO: search for identifier in symtab
	output_name {
		json ast = {
			{"type", ND_OUTPUT},
			{"name", $1}
		};
		$$ = move(ast);
	}
	;
io_declarations:
	io_declarations io_declaration {
		$1.push_back($2);
		$$ = move($1);
	}
	| {} /* empty */
	;
io_declaration:
	input_declaration {
		$$ = move($1);
	}
	| output_declaration {
		$$ = move($1);
	}
	;
input_declaration:
	INPUT input_name ';' {
		json ast = {
			{"type", ND_INPUT},
			{"name", $2},
			{"size", 1}
		};
		$$ = move(ast);
	}
	| INPUT input_name '[' NUMBER ']' ';' {
		json ast = {
			{"type", ND_INPUT},
			{"name", $2},
			{"size", $4}
		};
		$$ = move(ast);
	}
	;
input_name:
	IDENTIFIER {
		$$ = $1;
	}
	;
output_declaration:
	OUTPUT output_name ';' {
		json ast = {
			{"type", ND_OUTPUT},
			{"name", $2},
			{"size", 1}
		};
		$$ = move(ast);
	}
	| OUTPUT output_name '[' NUMBER ']' ';' {
		json ast = {
			{"type", ND_OUTPUT},
			{"name", $2},
			{"size", $4}
		};
	}
	;
output_name:
	IDENTIFIER {
		$$ = $1;
	}
	;
expression:
	conditional_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"expr", $1}
		};
		$$ = move(ast);
	}
	;
conditional_expression:
	logical_or_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"expr", $1}
		};
		$$ = move(ast);
	}
	;
logical_or_expression:
	logical_and_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"expr", $1}
		};
		$$ = move(ast);
	}
	| logical_or_expression '|' '|' logical_and_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"kind", ND_LOGICAL_OR},
			{"left", $1},
			{"right", $4}
		};
		$$ = move(ast);
	}
	;
logical_and_expression:
	relational_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"expr", $1}
		};
		$$ = move(ast);
	}
	| logical_and_expression '&' '&' relational_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"kind", ND_LOGICAL_AND},
			{"left", $1},
			{"right", $4}
		};
		$$ = move(ast);
	}
	;
relational_expression:
	equalitiy_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"expr", $1}
		};
		$$ = move(ast);
	}
	| relational_expression '>' equalitiy_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"kind", ND_GREATER},
			{"left", $1},
			{"right", $3}
		};
		$$ = move(ast);
	}
	| relational_expression '<' equalitiy_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"kind", ND_LESS},
			{"left", $1},
			{"right", $3}
		};
		$$ = move(ast);
	}
	| relational_expression '>' '=' equalitiy_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"kind", ND_GREATER_EQUAL},
			{"left", $1},
			{"right", $4}
		};
		$$ = move(ast);
	}
	| relational_expression '<' '=' equalitiy_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"kind", ND_LESS_EQUAL},
			{"left", $1},
			{"right", $4}
		};
		$$ = move(ast);		
	}
	;

equalitiy_expression:
	shift_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"expr", $1}
		};
		$$ = move(ast);
	}
	| equalitiy_expression '=' '=' shift_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"kind", ND_EQUAL},
			{"left", $1},
			{"right", $4}
		};
		$$ = move(ast);
	}
	| equalitiy_expression '!' '=' shift_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"kind", ND_NOT_EQUAL},
			{"left", $1},
			{"right", $4}
		};
		$$ = move(ast);
	}
	;

shift_expression:
	additive_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"expr", $1}
		};
		$$ = move(ast);
	}
	| shift_expression '<' '<' additive_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"kind", ND_SHIFT_LEFT},
			{"left", $1},
			{"right", $4}
		};
		$$ = move(ast);
	}
	| shift_expression '>' '>' additive_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"kind", ND_SHIFT_RIGHT},
			{"left", $1},
			{"right", $4}
		};
		$$ = move(ast);
	}
	;
additive_expression:
	multiplicative_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"expr", $1}
		};
		$$ = move(ast);
	}
	| additive_expression '+' multiplicative_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"kind", ND_ADD},
			{"left", $1},
			{"right", $3}
		};
		$$ = move(ast);
	}
	| additive_expression '-' multiplicative_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"kind", ND_SUB},
			{"left", $1},
			{"right", $3}
		};
		$$ = move(ast);
	}
	;
multiplicative_expression:
	bitwise_or_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"expr", $1}
		};
		$$ = move(ast);
	}
	| multiplicative_expression '*' bitwise_or_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"kind", ND_MUL},
			{"left", $1},
			{"right", $3}
		};
		$$ = move(ast);
	}
	;
bitwise_or_expression:
	bitwise_xor_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"expr", $1}
		};
		$$ = move(ast);
	}
	| bitwise_or_expression '|' bitwise_xor_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"kind", ND_BITWISE_OR},
			{"left", $1},
			{"right", $3}
		};
		$$ = move(ast);
	}
	;
bitwise_xor_expression:
	bitwise_and_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"expr", $1}
		};
		$$ = move(ast);
	}
	| bitwise_xor_expression '^' bitwise_and_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"kind", ND_BITWISE_XOR},
			{"left", $1},
			{"right", $3}
		};
		$$ = move(ast);
	}
	;
bitwise_and_expression:
	unary_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"expr", $1}
		};
		$$ = move(ast);
	}
	| bitwise_and_expression '&' unary_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"kind", ND_BITWISE_AND},
			{"left", $1},
			{"right", $3}
		};
		$$ = move(ast);
	}
	;
unary_expression:
	'^' unary_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"kind", ND_REDUCTION_XOR},
			{"expr", $2}
		};
		$$ = move(ast);
	}
	| '|' unary_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"kind", ND_REDUCTION_OR},
			{"expr", $2}
		};
		$$ = move(ast);		
	}
	| '&' unary_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"kind", ND_REDUCTION_AND},
			{"expr", $2}
		};
		$$ = move(ast);
	}
	| '~' unary_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"kind", ND_REDUCTION_NOT},
			{"expr", $2}
		};
		$$ = move(ast);
	}
	| '!' unary_expression {
		json ast = {
			{"type", ND_EXPRESSION},
			{"kind", ND_LOGICAL_NOT},
			{"expr", $2}
		};
		$$ = move(ast);
	}
	| element {
		json ast = {
			{"type", ND_EXPRESSION},
			{"expr", $1}
		};
	}
element:
	IDENTIFIER {
		json ast = {
			{"type", ND_ELEMENT},
			{"name", $1}
		};
		$$ = move(ast);
	}
%%


void
NSLXPP::NSLXPP_Parser::error(const location_type& loc, const std::string& msg)
{
  std::cerr << msg << '\n';
}

