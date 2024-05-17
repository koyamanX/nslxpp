%{
#include "nslxx.tab.hh"
#include "nslxx_scanner.hh"

#undef YY_DECL
#define YY_DECL int NSLXX::NSLXX_Scanner::yylex(NSLXX_Parser::semantic_type * const yylval, \
                      NSLXX_Parser::location_type *location)
%}

%option c++
%option noyywrap
%option yyclass="NSLXX_Scanner"
%option nodefault

%%
declare {
	return NSLXX_Parser::token::DECLARE;
}
module {
	return NSLXX_Parser::token::MODULE;
}
struct {
	return NSLXX_Parser::token::STRUCT;
}
input {
	return NSLXX_Parser::token::INPUT;
}
output {
	return NSLXX_Parser::token::OUTPUT;
}
inout {
	return NSLXX_Parser::token::INOUT;
}
func_in {
	return NSLXX_Parser::token::FUNC_IN;
}
func_out {
	return NSLXX_Parser::token::FUNC_OUT;
}
reg {
	return NSLXX_Parser::token::REG;
}
wire {
	return NSLXX_Parser::token::WIRE;
}
func_self {
	return NSLXX_Parser::token::FUNC_SELF;
}
mem {
	return NSLXX_Parser::token::MEM;
}
state_name {
	return NSLXX_Parser::token::STATE_NAME;
}
proc_name {
	return NSLXX_Parser::token::PROC_NAME;
}
[A-Za-z][_A-Za-z0-9]* {
	//yylval.ident = strdup(yytext);
	yylval->build<std::string>(yytext);
	return NSLXX_Parser::token::IDENTIFIER;
}
[1-9][0-9]* {
	yylval->build<int>(atoi(yytext));
	return NSLXX_Parser::token::NUMBER;
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


