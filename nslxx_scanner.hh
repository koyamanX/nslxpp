#ifndef NSLXX_SCANNER_HH
#define NSLXX_SCANNER_HH

#if !defined(yyFlexLexerOnce)
#include <FlexLexer.h>
#endif

namespace NSLXX {

class NSLXX_Scanner : public yyFlexLexer {
public:
    NSLXX_Scanner(std::istream* in = 0)
        : yyFlexLexer(in) {

        };
    virtual ~NSLXX_Scanner() {

    };
    using FlexLexer::yylex;

    virtual int yylex(NSLXX_Parser::value_type* const lval,
        NSLXX_Parser::location_type* location);

private:
    NSLXX_Parser::value_type* yylval = nullptr;
};
} // namespace NSLXX

#endif