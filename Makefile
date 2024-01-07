CXX=g++
CXXFLAGS=-std=c++20
FLEX=flex++
FLEXOPT=-+
BISON=bison
BISONOPT=

TOP=nslxpp
SRC=nslxpp.tab.cc lex.yy.cc nslxpp.cc main.cc nslgen.cc nslxpp_parser.cc
OBJ=$(SRC:.cc=.o)
AUTOGEN=nslxpp.tab.cc nslxpp.tab.hh lex.yy.cc position.hh stack.hh location.hh

.PHONY: all clean
.SUFFIXES: .cc .o .d

all: $(TOP)

-include $(SRC:.cc=.d)

%.d: %.cc
	$(CXX) $(CXXFLAGS) -MM -MT $(@:.d=.o) $< -o $@
nslxpp.tab.cc: nslxpp.yy
	$(BISON) $(BISONOPT) -o $@ $<
lex.yy.cc: nslxpp.ll nslxpp.tab.cc
	$(FLEX) $(FLEXOPT) -o $@ $<
%.o: %.cc
	$(CXX) $(CXXFLAGS) -c $< -o $@
$(TOP): $(OBJ)
	$(CXX) $(CXXFLAGS) $^ -o $@
clean:
	rm -f $(OBJ) $(TOP) $(AUTOGEN)
