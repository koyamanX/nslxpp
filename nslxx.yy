%skeleton "lalr1.cc"
%require "3.2"
%defines
%define api.value.type variant
//%define api.token.constructor
%define api.namespace {NSLXX}
%define api.parser.class {NSLXX_Parser}
%locations
%define parse.error	custom

%code requires {
#include <string>
#include <vector>
#include <map>
#include <iostream>
#include <fstream>
#include <sstream>
#include <memory>
#include "nslxx.hh"
#include "scope.hh"
#include "node.hh"
namespace NSLXX {
	class NSLXX_Parser;
	class NSLXX_Scanner;
	class NSLXX_Driver; // Added NSLXX_Driver class
}
}

%parse-param { NSLXX_Scanner& scanner }
%parse-param { NSLXX_Driver &nslxx }

%code {
#include "nslxx_scanner.hh"

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

%type <Node *> module_declaration
%type <std::string> module_name
%type <ScopeNode *> io_declarations
%type <std::string> input_name
%type <std::string> output_name
%type <std::string> declare_name

%type <Node *> module_definition
%type <std::vector<Node *>> common_tasks
%type <Node *> common_task
%type <Node *> lvalue
%type <Node *> expression
%type <Node *> conditional_expression
%type <Node *> logical_or_expression
%type <Node *> logical_and_expression
%type <Node *> relational_expression
%type <Node *> equalitiy_expression
%type <Node *> shift_expression
%type <Node *> additive_expression
%type <Node *> multiplicative_expression
%type <Node *> bitwise_or_expression
%type <Node *> bitwise_xor_expression
%type <Node *> bitwise_and_expression
%type <Node *> unary_expression
%type <Node *> element
%type <Node *> wire_declaration
%type <Node *> reg_declaration
%type <Node *> mem_declaration
%type <Node *> nsl
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
		$$ = $1;
	}
	| module_definition {
		$$ = $1;
	}
	;
module_declaration:
	DECLARE declare_name '{' {nslxx.scope.enter();} io_declarations '}' {nslxx.scope.leave();} {
		auto node = Node::new_node_declare(nslxx.scope.get_scope());
		nslxx.scope.add_declare($declare_name, node);
		$$ = node;
	}
	;
module_definition:
	MODULE module_name '{' {nslxx.scope.enter();} common_tasks module_signal_declarations '}' {nslxx.scope.leave();} {
		auto node = Node::new_node_module(nslxx.scope.get_scope(), &$common_tasks);
		nslxx.scope.add_module($module_name, node);
		$$ = node;
	}
	;
declare_name:
	IDENTIFIER
	;
module_name:
	IDENTIFIER
	;
common_tasks:
	common_tasks common_task {
		$1.push_back($2);
		$$ = $1;
	}
	| {} /* empty */
	;
common_task:
	lvalue '=' expression ';' {
		auto node = Node::new_node_assign($lvalue, $expression);
		$$ = node;
	}
	;
module_signal_declarations:
	module_signal_declarations module_signal_declaration {}
	| {} /* empty */
	;
module_signal_declaration:
	wire_declaration {}
	| reg_declaration {}
	| mem_declaration {}
	;
wire_declaration:
	WIRE IDENTIFIER ';' {
		auto node = Node::new_node_wire();
		nslxx.scope.add_var($2, node);
		$$ = node;
	}
	| WIRE IDENTIFIER '[' NUMBER ']' ';' {
		auto node = Node::new_node_wire($4);
		nslxx.scope.add_var($2, node);
		$$ = node;
	}
	;
reg_declaration:
	REG IDENTIFIER ';' {
		auto node = Node::new_node_reg();
		nslxx.scope.add_var($2, node);
		$$ = node;
	}
	| REG IDENTIFIER '[' NUMBER ']' ';' {
		auto node = Node::new_node_reg($4);
		nslxx.scope.add_var($2, node);
		$$ = node;
	}
	;
mem_declaration:
	MEM IDENTIFIER '[' NUMBER ']' ';' {
		auto node = Node::new_node_mem($4);
		nslxx.scope.add_var($2, node);
		$$ = node;
	}
	| MEM IDENTIFIER '[' NUMBER ']' '[' NUMBER ']' ';' {
		auto node = Node::new_node_mem($4, $7);
		nslxx.scope.add_var($2, node);
		$$ = node;
	}
	;
lvalue:
	output_name {
		auto node = Node::new_node_lvalue($1);
		$$ = node;
	}
	;
io_declarations:
	io_declarations io_declaration {}
	| {} /* empty */
	;
io_declaration:
	input_declaration {}
	| output_declaration {}
	;
input_declaration:
	INPUT input_name ';' {
		auto node = Node::new_node_input();
		nslxx.scope.add_var($input_name, node);
	}
	| INPUT input_name '[' NUMBER ']' ';' {
		auto node = Node::new_node_input($4);
		nslxx.scope.add_var($input_name, node);
	}
	;
input_name:
	IDENTIFIER {
		$$ = $1;
	}
	;
output_declaration:
	OUTPUT output_name ';' {
		auto node = Node::new_node_output();
		nslxx.scope.add_var($output_name, node);
	}
	| OUTPUT output_name '[' NUMBER ']' ';' {
		auto node = Node::new_node_output($4);
		nslxx.scope.add_var($output_name, node);
	}
	;
output_name:
	IDENTIFIER {
		$$ = $1;
	}
	;
expression:
	conditional_expression {
		$$ = $1;
	}
	;
conditional_expression:
	logical_or_expression {
		$$ = $1;
	}
	;
logical_or_expression:
	logical_and_expression {
		$$ = $1;
	}
	| logical_or_expression '|' '|' logical_and_expression {
		auto node = Node::new_node_expression(ND_LOGICAL_OR, $1, $4);
		$$ = node;
	}
	;
logical_and_expression:
	relational_expression {
		$$ = $1;
	}
	| logical_and_expression '&' '&' relational_expression {
		auto node = Node::new_node_expression(ND_LOGICAL_AND, $1, $4);
		$$ = node;
	}
	;
relational_expression:
	equalitiy_expression {
		$$ = $1;
	}
	| relational_expression '>' equalitiy_expression {
		auto node = Node::new_node_expression(ND_GREATER, $1, $3);
		$$ = node;
	}
	| relational_expression '<' equalitiy_expression {
		auto node = Node::new_node_expression(ND_LESS, $1, $3);
		$$ = node;
	}
	| relational_expression '>' '=' equalitiy_expression {
		auto node = Node::new_node_expression(ND_GREATER_EQUAL, $1, $4);
		$$ = node;
	}
	| relational_expression '<' '=' equalitiy_expression {
		auto node = Node::new_node_expression(ND_LESS_EQUAL, $1, $4);
		$$ = node;		
	}
	;

equalitiy_expression:
	shift_expression {
		$$ = $1;
	}
	| equalitiy_expression '=' '=' shift_expression {
		auto node = Node::new_node_expression(ND_EQUAL, $1, $4);
		$$ = node;
	}
	| equalitiy_expression '!' '=' shift_expression {
		auto node = Node::new_node_expression(ND_NOT_EQUAL, $1, $4);
		$$ = node;
	}
	;

shift_expression:
	additive_expression {
		$$ = $1;
	}
	| shift_expression '<' '<' additive_expression {
		auto node = Node::new_node_expression(ND_SHIFT_LEFT, $1, $4);
		$$ = node;
	}
	| shift_expression '>' '>' additive_expression {
		auto node = Node::new_node_expression(ND_SHIFT_RIGHT, $1, $4);
		$$ = node;
	}
	;
additive_expression:
	multiplicative_expression {
		$$ = $1;
	}
	| additive_expression '+' multiplicative_expression {
		auto node = Node::new_node_expression(ND_ADD, $1, $3);
		$$ = node;
	}
	| additive_expression '-' multiplicative_expression {
		auto node = Node::new_node_expression(ND_SUB, $1, $3);
		$$ = node;
	}
	;
multiplicative_expression:
	bitwise_or_expression {
		$$ = $1;
	}
	| multiplicative_expression '*' bitwise_or_expression {
		auto node = Node::new_node_expression(ND_MUL, $1, $3);
		$$ = node;
	}
	;
bitwise_or_expression:
	bitwise_xor_expression {
		$$ = $1;
	}
	| bitwise_or_expression '|' bitwise_xor_expression {
		auto node = Node::new_node_expression(ND_BITWISE_OR, $1, $3);
		$$ = node;
	}
	;
bitwise_xor_expression:
	bitwise_and_expression {
		$$ = $1;
	}
	| bitwise_xor_expression '^' bitwise_and_expression {
		auto node = Node::new_node_expression(ND_BITWISE_XOR, $1, $3);
		$$ = node;
	}
	;
bitwise_and_expression:
	unary_expression {
		$$ = $1;
	}
	| bitwise_and_expression '&' unary_expression {
		auto node = Node::new_node_expression(ND_BITWISE_AND, $1, $3);
		$$ = node;
	}
	;
unary_expression:
	'^' unary_expression {
		auto node = Node::new_node_expression(ND_REDUCTION_XOR, $2);
		$$ = node;
	}
	| '|' unary_expression {
		auto node = Node::new_node_expression(ND_REDUCTION_OR, $2);
		$$ = node;		
	}
	| '&' unary_expression {
		auto node = Node::new_node_expression(ND_REDUCTION_AND, $2);
		$$ = node;
	}
	| '~' unary_expression {
		auto node = Node::new_node_expression(ND_REDUCTION_NOT, $2);
		$$ = node;
	}
	| '!' unary_expression {
		auto node = Node::new_node_expression(ND_NOT, $2);
		$$ = node;
	}
	| element {
		$$ = $1;
	}
element:
	IDENTIFIER {
		auto node = Node::new_node_element($1);
		$$ = node;
	}
%%