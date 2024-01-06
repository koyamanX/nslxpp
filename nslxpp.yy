%skeleton "lalr1.cc"
%require "3.0"
%defines
%define api.value.type variant
//%define api.token.constructor
%define api.namespace {NSLXPP}
%define api.parser.class {NSLXPP_Parser}
%locations
%define parse.error	custom

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
%token FUNC_IN FUNC_OUT FUNC_SELF
%token WIRE REG MEM
%token PROC_NAME
%token STATE_NAME

%type <json> module_declaration
%type <std::string> module_name
%type <std::map<std::string, json>> io_declarations
%type <json> io_declaration
%type <json> input_declaration
%type <json> output_declaration
%type <std::string> input_name
%type <std::string> output_name
%type <std::string> declare_name
%type <json> func_in_declaration
%type <json> func_out_declaration
%type <std::vector<json>> func_in_params
%type <std::vector<json>> func_out_params

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
%type <std::map<std::string, json>> module_signal_declarations
%type <json> module_signal_declaration
%type <json> wire_declaration
%type <json> reg_declaration
%type <json> func_self_declaration
%type <std::vector<json>> func_self_params
%type <json> func_self_return
%type <json> mem_declaration
%type <json> state_name_declaration
%type <std::vector<json>> state_name_declaration_list
%type <json> proc_name_declaration
%type <std::vector<json>> proc_name_params

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
		nslxpp.add_declare($1["name"], $1);
	}
	| module_definition {
		nslxpp.add_module($1["name"], $1);
	}
	;
module_declaration:
	DECLARE declare_name '{' io_declarations '}' {
		json ast = {
			{"type", ND_DECLARE},
			{"name", $2},
			{"io", $4}
		};
		$$ = move(ast);
	}
	;
module_definition:
	MODULE module_name '{' common_tasks module_signal_declarations state_name_declaration '}' {
		json ast = {
			{"type", ND_MODULE},
			{"name", $2},
			{"common_tasks", $4},
			{"signals", $5},
			{"states", $6}
		};
		$$ = move(ast);
	}
	;
declare_name:
	IDENTIFIER
	;
module_name:
	IDENTIFIER { nslxpp.set_current_module($1); $$ = $1; }
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
			{"left", $1},
			{"right", $3}
		};
		$$ = move(ast);
	}
	;
module_signal_declarations:
	module_signal_declarations module_signal_declaration {
		if ($1.find($2["name"]) != $1.end()) {
			std::cerr << "error: duplicate declaration of " << $2["name"] << std::endl;
			exit(1);
		}
		$1.emplace($2["name"], $2);
		$$ = move($1);
	}
	| {} /* empty */
	;
module_signal_declaration:
	wire_declaration {
		$$ = move($1);
	}
	| reg_declaration {
		$$ = move($1);
	}
	| mem_declaration {
		$$ = move($1);
	}
	| func_self_declaration {
		$$ = move($1);
	}
	| proc_name_declaration {
		$$ = move($1);
	}
	;
wire_declaration:
	WIRE IDENTIFIER ';' {
		json ast = {
			{"type", ND_WIRE},
			{"name", $2},
			{"size", 1}
		};
		$$ = move(ast);
	}
	| WIRE IDENTIFIER '[' NUMBER ']' ';' {
		json ast = {
			{"type", ND_WIRE},
			{"name", $2},
			{"size", $4}
		};
		$$ = move(ast);
	}
	;
reg_declaration:
	REG IDENTIFIER ';' {
		json ast = {
			{"type", ND_REG},
			{"name", $2},
			{"size", 1}
		};
		$$ = move(ast);
	}
	| REG IDENTIFIER '[' NUMBER ']' ';' {
		json ast = {
			{"type", ND_REG},
			{"name", $2},
			{"size", $4}
		};
		$$ = move(ast);
	}
	;
mem_declaration:
	MEM IDENTIFIER '[' NUMBER ']' ';' {
		json ast = {
			{"type", ND_MEM},
			{"name", $2},
			{"size", $4},
			{"depth", 1}
		};
		$$ = move(ast);
	}
	| MEM IDENTIFIER '[' NUMBER ']' '[' NUMBER ']' ';' {
		json ast = {
			{"type", ND_MEM},
			{"name", $2},
			{"size", $4},
			{"depth", $7}
		};
		$$ = move(ast);
	}
	;
func_self_declaration:
	FUNC_SELF IDENTIFIER ';' {
		json ast = {
			{"type", ND_FUNC_SELF},
			{"name", $2},
			{"size", 1}
		};
		$$ = move(ast);
	}
	| FUNC_SELF IDENTIFIER '(' func_self_params ')' ';' {
		json ast = {
			{"type", ND_FUNC_SELF},
			{"params", $4},
			{"name", $2},
			{"size", 1}
		};
		$$ = move(ast);
	}
	| FUNC_SELF IDENTIFIER '(' func_self_params ')' ':' func_self_return ';' {
		json ast = {
			{"type", ND_FUNC_SELF},
			{"params", $4},
			{"return", $7},
			{"name", $2},
			{"size", 1}
		};
		$$ = move(ast);
	}
	;
func_self_params:
	func_self_params ',' IDENTIFIER {
		$1.push_back($3);
		$$ = move($1);
	}
	| IDENTIFIER {
		$$ = std::vector<json>{ $1 };
	}
	| {} /* empty */
	;
func_self_return:
	IDENTIFIER {
		$$ = $1;
	}
	;
state_name_declaration:
	STATE_NAME state_name_declaration_list ';' {
		json ast = {
			{"type", ND_STATE_NAME},
			{"names", $2}
		};
		$$ = move(ast);
	}
	| {} /* empty */
	;
state_name_declaration_list:
	state_name_declaration_list ',' IDENTIFIER {
		$1.push_back($3);
		$$ = move($1);
	}
	| IDENTIFIER {
		json ast = {
			{"type", ND_STATE},
			{"name", $1}
		};
		$$ = std::vector<json>{ move(ast) };
	}
	;
proc_name_declaration:
	PROC_NAME IDENTIFIER '(' proc_name_params ')' ';' {
		json ast = {
			{"type", ND_PROC_NAME},
			{"name", $2},
			{"params", $4}
		};
		$$ = move(ast);
	}
	;
proc_name_params:
	proc_name_params ',' IDENTIFIER {
		$1.push_back($3);
		$$ = move($1);
	}
	| IDENTIFIER {
		$$ = std::vector<json>{ $1 };
	}
	| {} /* empty */
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
		if ($1.find($2["name"]) != $1.end()) {
			std::cerr << "error: duplicate declaration of " << $2["name"] << std::endl;
			exit(1);
		}
		$1.emplace($2["name"], $2);
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
	| func_in_declaration {
		$$ = move($1);
	}
	| func_out_declaration {
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
func_in_declaration:
	FUNC_IN input_name ';' {
		json ast = {
			{"type", ND_FUNC_IN},
			{"name", $2},
			{"size", 1}
		};
		$$ = move(ast);
	}
	| FUNC_IN input_name '(' func_in_params ')' ';' {
		json ast = {
			{"type", ND_FUNC_IN},
			{"params", $4},
			{"name", $2},
			{"size", 1}
		};
		$$ = move(ast);
	}
	| FUNC_IN input_name '(' func_in_params ')' ':' output_name ';' {
		json ast = {
			{"type", ND_FUNC_IN},
			{"params", $4},
			{"return", $7},
			{"name", $2},
			{"size", 1}
		};
		$$ = move(ast);
	}
	;
func_in_params:
	func_in_params ',' input_name {
		$1.push_back($3);
		$$ = move($1);
	}
	| input_name {
		$$ = std::vector<json>{ $1 };
	}
	| {} /* empty */
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
		$$ = move(ast);
	}
	;
func_out_declaration:
	FUNC_OUT output_name ';' {
		json ast = {
			{"type", ND_FUNC_OUT},
			{"name", $2},
			{"size", 1}
		};
		$$ = move(ast);
	}
	| FUNC_OUT output_name '(' func_out_params ')' ';' {
		json ast = {
			{"type", ND_FUNC_OUT},
			{"params", $4},
			{"name", $2},
			{"size", 1}
		};
		$$ = move(ast);
	}
	| FUNC_OUT output_name '(' func_out_params ')' ':' input_name ';' {
		json ast = {
			{"type", ND_FUNC_OUT},
			{"params", $4},
			{"return", $7},
			{"name", $2},
			{"size", 1}
		};
		$$ = move(ast);
	}
	;
func_out_params:
	func_out_params ',' output_name {
		$1.push_back($3);
		$$ = move($1);
	}
	| output_name {
		$$ = std::vector<json>{ $1 };
	}
	| {} /* empty */
	;
output_name:
	IDENTIFIER {
		$$ = $1;
	}
	;
expression:
	conditional_expression {
		$$ = move($1);
	}
	;
conditional_expression:
	logical_or_expression {
		$$ = move($1);
	}
	;
logical_or_expression:
	logical_and_expression {
		$$ = move($1);
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
		$$ = move($1);
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
		$$ = move($1);
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
		$$ = move($1);
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
		$$ = move($1);
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
		$$ = move($1);
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
		$$ = move($1);
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
		$$ = move($1);
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
		$$ = move($1);
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
		$$ = move($1);
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
		$$ = move(ast);
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
}

void
NSLXPP::NSLXPP_Parser::report_syntax_error(const NSLXPP::NSLXPP_Parser::context& ctx) const
{
	int res = 0;
	std::cerr << ctx.location () << ": syntax error";
	// Report the tokens expected at this point.
	{
		enum { TOKENMAX = 5 };
		symbol_kind_type expected[TOKENMAX];
		int n = ctx.expected_tokens (expected, TOKENMAX);
		for (int i = 0; i < n; ++i)
			std::cerr << (i == 0 ? ": expected " : " or ")
								<< symbol_name (expected[i]);
	}
	// Report the unexpected token.
	{
		symbol_kind_type lookahead = ctx.token ();
		if (lookahead != symbol_kind::S_YYEMPTY)
			std::cerr << " before " << symbol_name (lookahead);
	}
	std::cerr << '\n';
}
