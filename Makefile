CXX=g++
CXXFLAGS=-std=c++20
FLEX=flex++
FLEXOPT=-+
BISON=bison
BISONOPT=

TOP=nslxpp
SRC=nslxpp.tab.cc lex.yy.cc nslxpp.cc main.cc nslgen.cc nslxpp_parser.cc
OBJ=$(SRC:.cc=.o)
AUTOGEN=nslxpp.tab.cc nslxpp.tab.hh lex.yy.cc position.hh stack.hh location.hh *.d

.PHONY: all clean
.SUFFIXES: .cc .o .d

all: $(TOP)

-include $(SRC:.cc=.d)

%.tab.cc %.tab.hh: %.yy
	$(BISON) $(BISONOPT) $<
lex.yy.cc: nslxpp.ll nslxpp.tab.hh
	$(FLEX) $(FLEXOPT) -o $@ $<
%.o: %.cc nslxpp.tab.hh
	$(CXX) $(CXXFLAGS) -c $< -o $@
%.d: %.cc nslxpp.tab.hh
	$(CXX) $(CXXFLAGS) -MM -MT $(@:.d=.o) $< -o $@
$(TOP): $(OBJ)
	$(CXX) $(CXXFLAGS) $^ -o $@

clean:
	rm -f $(OBJ) $(TOP) $(AUTOGEN)
