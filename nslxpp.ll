%{

#include "nslxpp.hh"
#include "nslxpp.tab.hh"
#include "nslxpp_scanner.hh"

#undef YY_DECL
#define YY_DECL int NSLXPP::NSLXPP_Scanner::yylex(NSLXPP::NSLXPP_Parser::semantic_type * const yylval, \
                      NSLXPP::NSLXPP_Parser::location_type *location)
%}

%option c++
%option noyywrap
%option yyclass="NSLXPP::NSLXPP_Scanner"
%option nodefault

%%
declare {
	return NSLXPP::NSLXPP_Parser::token::DECLARE;
}
module {
	return NSLXPP::NSLXPP_Parser::token::MODULE;
}
struct {
	return NSLXPP::NSLXPP_Parser::token::STRUCT;
}
input {
	return NSLXPP::NSLXPP_Parser::token::INPUT;
}
output {
	return NSLXPP::NSLXPP_Parser::token::OUTPUT;
}
inout {
	return NSLXPP::NSLXPP_Parser::token::INOUT;
}
[A-Za-z][_A-Za-z0-9]* {
	//yylval.ident = strdup(yytext);
	yylval->build<std::string>(yytext);
	return NSLXPP::NSLXPP_Parser::token::IDENTIFIER;
}
[1-9][0-9]* {
	//yylval.size = atoll(yytext);
	return NSLXPP::NSLXPP_Parser::token::NUMBER;
}
[\n\t ]+ {
	;
}
[\(\)\[\]{};] {
	return *yytext;
}
[\:\=\+\-\*\<\>\!\&\^\|\.\~] {
	return *yytext;
}
[#'] {
	return *yytext;
}
. {
	//yyerror("Unknown");
}
%%


