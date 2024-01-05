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
#include "nslxpp.hh"
namespace NSLXPP {
	class NSLXPP_Parser;
	class NSLXPP_Scanner;
}
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
	module_declaration
	| module_definition
	;
module_declaration:
	DECLARE module_name '{' io_declarations '}' {
		// insert map created by io_declarations
	}
	;
module_definition:
	MODULE module_name '{' common_tasks '}' {
	}
	;
module_name:
	IDENTIFIER
	;
common_tasks:
	common_tasks common_task {
		
	}
	|
	;
common_task:
	lvalue '=' expression ';' {

	}
	;
lvalue:
	output_name {

	}
	;
io_declarations:
	io_declarations io_declaration {
		// create empty map, returns at the end.
	}
	|
	;
io_declaration:
	input_declaration {
		
	}
	| output_declaration {
		
	}
	;
input_declaration:
	INPUT input_name ';' {
		
	}
	| INPUT input_name '[' NUMBER ']' ';' {
		
	}
	;
input_name:
	IDENTIFIER {
		
	}
	;
output_declaration:
	OUTPUT output_name ';' {
		
	}
	| OUTPUT output_name '[' NUMBER ']' ';' {
		
	}
	;
output_name:
	IDENTIFIER {
		
	}
	;
expression:
	conditional_expression {
		
	}
	;
conditional_expression:
	logical_or_expression {
		
	}
	;
logical_or_expression:
	logical_and_expression {
		
	}
	| logical_or_expression '|' '|' logical_and_expression {
		
	}
	;
logical_and_expression:
	relational_expression {
		
	}
	| logical_and_expression '&' '&' relational_expression {
		
	}
	;
relational_expression:
	equalitiy_expression {
		
	}
	| relational_expression '>' equalitiy_expression {
		
	}
	| relational_expression '<' equalitiy_expression {
		
	}
	| relational_expression '>' '=' equalitiy_expression {
		
	}
	| relational_expression '<' '=' equalitiy_expression {
		
	}
	;

equalitiy_expression:
	shift_expression {
		
	}
	| equalitiy_expression '=' '=' shift_expression {
		
	}
	| equalitiy_expression '!' '=' shift_expression {
		
	}
	;

shift_expression:
	additive_expression {
		
	}
	| shift_expression '<' '<' additive_expression {
		
	}
	| shift_expression '>' '>' additive_expression {
		
	}
	;
additive_expression:
	multiplicative_expression {
		
	}
	| additive_expression '+' multiplicative_expression {
		
	}
	| additive_expression '-' multiplicative_expression {
		
	}
	;
multiplicative_expression:
	bitwise_or_expression {
		
	}
	| multiplicative_expression '*' bitwise_or_expression {
		
	}
	;
bitwise_or_expression:
	bitwise_xor_expression {
		
	}
	| bitwise_or_expression '|' bitwise_xor_expression {
		
	}
	;
bitwise_xor_expression:
	bitwise_and_expression {
		
	}
	| bitwise_xor_expression '^' bitwise_and_expression {
		
	}
	;
bitwise_and_expression:
	unary_expression {
		
	}
	| bitwise_and_expression '&' unary_expression {
		
	}
	;
unary_expression:
	'^' unary_expression {
		
	}
	| '|' unary_expression {
		
	}
	| '&' unary_expression {
		
	}
	| '~' unary_expression {
		
	}
	| '!' unary_expression {
		
	}
	| element {
		
	}
element:
	IDENTIFIER {

	}
%%


void
NSLXPP::NSLXPP_Parser::error(const location_type& loc, const std::string& msg)
{
  std::cerr << msg << '\n';
}

