CXX=g++
CXXFLAGS=-std=c++20
FLEX=flex++
FLEXOPT=-+
BISON=bison
BISONOPT=

TOP=nslxx
SRC=nslxx.tab.cc lex.yy.cc nslxx.cc main.cc nslgen.cc nslxx_parser.cc node.cc scope.cc
OBJ=$(SRC:.cc=.o)
AUTOGEN=nslxx.tab.cc nslxx.tab.hh lex.yy.cc position.hh stack.hh location.hh *.d

.PHONY: all clean
.SUFFIXES: .cc .o .d

all: $(TOP)

-include $(SRC:.cc=.d)

%.tab.cc %.tab.hh: %.yy
	$(BISON) $(BISONOPT) $<
lex.yy.cc: nslxx.ll nslxx.tab.hh
	$(FLEX) $(FLEXOPT) -o $@ $<
%.o: %.cc nslxx.tab.hh
	$(CXX) $(CXXFLAGS) -c $< -o $@
%.d: %.cc nslxx.tab.hh
	$(CXX) $(CXXFLAGS) -MM -MT $(@:.d=.o) $< -o $@
$(TOP): $(OBJ)
	$(CXX) $(CXXFLAGS) $^ -o $@

clean:
	rm -f $(OBJ) $(TOP) $(AUTOGEN)
