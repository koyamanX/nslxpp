#include "nslxx.tab.hh"

void NSLXX::NSLXX_Parser::error(const location_type& loc,
                                  const std::string& msg) {}

void NSLXX::NSLXX_Parser::report_syntax_error(
    const NSLXX::NSLXX_Parser::context& ctx) const {
  int res = 0;
  std::cerr << ctx.location() << ": syntax error";
  // Report the tokens expected at this point.
  {
    enum { TOKENMAX = 5 };
    symbol_kind_type expected[TOKENMAX];
    int n = ctx.expected_tokens(expected, TOKENMAX);
    for (int i = 0; i < n; ++i)
      std::cerr << (i == 0 ? ": expected " : " or ")
                << symbol_name(expected[i]);
  }
  // Report the unexpected token.
  {
    symbol_kind_type lookahead = ctx.token();
    if (lookahead != symbol_kind::S_YYEMPTY)
      std::cerr << " before " << symbol_name(lookahead);
  }
  std::cerr << '\n';
}