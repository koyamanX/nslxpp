%{
#include "nslxpp.tab.hh"
#include "nslxpp_scanner.hh"

#undef YY_DECL
#define YY_DECL int NSLXPP::NSLXPP_Scanner::yylex(NSLXPP_Parser::semantic_type * const yylval, \
                      NSLXPP_Parser::location_type *location)
%}

%option c++
%option noyywrap
%option yyclass="NSLXPP_Scanner"
%option nodefault

%%
declare {
	return NSLXPP_Parser::token::DECLARE;
}
module {
	return NSLXPP_Parser::token::MODULE;
}
struct {
	return NSLXPP_Parser::token::STRUCT;
}
input {
	return NSLXPP_Parser::token::INPUT;
}
output {
	return NSLXPP_Parser::token::OUTPUT;
}
inout {
	return NSLXPP_Parser::token::INOUT;
}
func_in {
	return NSLXPP_Parser::token::FUNC_IN;
}
func_out {
	return NSLXPP_Parser::token::FUNC_OUT;
}
reg {
	return NSLXPP_Parser::token::REG;
}
wire {
	return NSLXPP_Parser::token::WIRE;
}
func_self {
	return NSLXPP_Parser::token::FUNC_SELF;
}
mem {
	return NSLXPP_Parser::token::MEM;
}
state_name {
	return NSLXPP_Parser::token::STATE_NAME;
}
proc_name {
	return NSLXPP_Parser::token::PROC_NAME;
}
[A-Za-z][_A-Za-z0-9]* {
	//yylval.ident = strdup(yytext);
	yylval->build<std::string>(yytext);
	return NSLXPP_Parser::token::IDENTIFIER;
}
[1-9][0-9]* {
	yylval->build<int>(atoi(yytext));
	return NSLXPP_Parser::token::NUMBER;
}
[\n\t ]+ {
	;
}
[\(\)\[\]{};] {
	return *yytext;
}
[\:\=\+\-\*\<\>\!\&\^\|\.\~\,] {
	return *yytext;
}
[#'] {
	return *yytext;
}
. {
	//yyerror("Unknown");
}
%%


