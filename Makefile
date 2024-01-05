CXX=g++
CXXFLAGS=-std=c++20
FLEX=flex++
FLEXOPT=-+
BISON=bison
BISONOPT=

TOP=nslxpp
SRC=nslxpp.tab.cc lex.yy.cc main.cc

all: $(TOP)
nslxpp.tab.cc: $(TOP).yy
	$(BISON) $(BISONOPT) $(TOP).yy
lex.yy.cc: $(TOP).ll
	$(FLEX) $(FLEXOPT) $(TOP).ll
$(TOP): $(SRC) 
	$(CXX) $(CXXFLAGS) $(SRC)  -o $@ -lfl
clean:
	rm -f $(OBJ) $(TOP) lex.yy.cc nslxpp.tab.cc nslxpp.tab.hh location.hh position.hh stack.hh
