%{
#include "nslxpp.hh"
#include "nslxpp.tab.hh"
%}

%option c++
%option noyywrap

%%
declare {
	return yy::parser::token::DECLARE;
}
module {
	return yy::parser::token::MODULE;
}
struct {
	return yy::parser::token::STRUCT;
}
input {
	return yy::parser::token::INPUT;
}
output {
	return yy::parser::token::OUTPUT;
}
inout {
	return yy::parser::token::INOUT;
}
[A-Za-z][_A-Za-z0-9]* {
	//yylval.ident = strdup(yytext);
	return yy::parser::token::IDENTIFIER;
}
[1-9][0-9]* {
	//yylval.size = atoll(yytext);
	return yy::parser::token::NUMBER;
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


