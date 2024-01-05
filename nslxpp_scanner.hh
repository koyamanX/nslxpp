#ifndef NSLXPP_SCANNER_HH
#define NSLXPP_SCANNER_HH

#if !defined(yyFlexLexerOnce)
#include <FlexLexer.h>
#endif

namespace NSLXPP {

class NSLXPP_Scanner : public yyFlexLexer {
public:

    NSLXPP_Scanner(std::istream *in = 0): yyFlexLexer(in)
    {

    };
    virtual ~NSLXPP_Scanner()
    {

    };
    using FlexLexer::yylex;

    virtual int yylex(NSLXPP_Parser::value_type * const lval,
                      NSLXPP_Parser::location_type *location);

private:
    NSLXPP_Parser::value_type *yylval = nullptr;
};
}

#endif