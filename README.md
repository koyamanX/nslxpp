# NSL++ 

## Introduction

## Pre-requisites

### Install dependencies

```bash
cat install_deps.sh # Check the dependencies
sudo ./install_deps.sh
```

### Build

## EBNF

```
<Program>         ::= { <ModuleDefinition> }
 
<ModuleDefinition> ::= <ModuleDeclPart> <ModuleBodyPart>
                     | <ModuleBodyPart> <ModuleDeclPart>   (* Order of declare/module is flexible&#8203;:contentReference[oaicite:4]{index=4} *)
 
<ModuleDeclPart>   ::= "declare" [ "interface" | "simulation" ] <Identifier> 
                       "{" { <ParameterDecl> } { <IODecl> } "}" 
                       (* Module interface declaration&#8203;:contentReference[oaicite:5]{index=5} *)
<ModuleBodyPart>   ::= "module" <Identifier> "{" 
                         { <InternalDecl> } 
                         { <ActionStmt> } 
                       "}"
                       (* Module implementation&#8203;:contentReference[oaicite:6]{index=6} *)
 
<ParameterDecl>   ::= "param_int" <Identifier> { "," <Identifier> } ";" 
                    | "param_str" <Identifier> { "," <Identifier> } ";" 
                    (* Integer/string parameter declaration&#8203;:contentReference[oaicite:7]{index=7} *)
 
<IODecl>          ::= ( "input" | "output" | "inout" ) [ "[" <Number> "]" ] 
                       <Identifier> { "," <Identifier> [ "[" <Number> "]" ] } ";" 
                    | "func_in"  <Identifier> "(" [ <DummyArgList> ] ")" [ ":" <Identifier> ] ";" 
                    | "func_out" <Identifier> "(" [ <DummyArgList> ] ")" [ ":" <Identifier> ] ";" 
                    (* Data I/O (with optional bus width) or control I/O (func_in/func_out)&#8203;:contentReference[oaicite:8]{index=8}&#8203;:contentReference[oaicite:9]{index=9} *)
 
<DummyArgList>    ::= <Identifier> { "," <Identifier> }
                     (* Dummy arguments for control functions (must be data I/O signals)&#8203;:contentReference[oaicite:10]{index=10} *)
 
<InternalDecl>    ::= "wire" <Identifier> [ "[" <Number> "]" ] { "," <Identifier> [ "[" <Number> "]" ] } ";" 
                    | "reg"  <Identifier> [ "[" <Number> "]" ] [ "=" <ConstExpr> ] 
                              { "," <Identifier> [ "[" <Number> "]" ] [ "=" <ConstExpr> ] } ";" 
                    | "mem"  <Identifier> "[" <Number> "]" "[" <Number> "]" 
                              [ "=" "{" <ConstExprList> "}" ] ";" 
                    | "state_name" <Identifier> { "," <Identifier> } ";" 
                    | "procedure" <Identifier> ";" 
                    | "func_self" <Identifier> "(" [ <DummyArgList> ] ")" [ ":" <Identifier> ] ";" 
                    | <SubmoduleInst> 
                    (* Internal signals (combinational "wire"&#8203;:contentReference[oaicite:11]{index=11}, sequential "reg"&#8203;:contentReference[oaicite:12]{index=12}), 
                       memory arrays&#8203;:contentReference[oaicite:13]{index=13}&#8203;:contentReference[oaicite:14]{index=14}, FSM state names, procedure and internal control declarations, 
                       or submodule instantiation. *)
 
<SubmoduleInst>   ::= <Identifier> <Identifier> "(" [ <ParamAssignList> ] ")" ";"
                     (* Instantiation of a submodule: ModuleType instanceName ( parameter assignments )&#8203;:contentReference[oaicite:15]{index=15} *)
<ParamAssignList> ::= <ParamAssign> { "," <ParamAssign> }
<ParamAssign>     ::= <Identifier> "=" <ConstExpr>
                     (* Assign actual parameters to submodule instance generics&#8203;:contentReference[oaicite:16]{index=16} *)
 
<ActionStmt>      ::= <Assignment> 
                    | <ProcedureCall> ";" 
                    | <FuncCall> ";" 
                    | <IfStmt> 
                    | <AltBlock> 
                    | <AnyBlock> 
                    | <ParBlock> 
                    | <WhileLoop> 
                    | <ForLoop> 
                    | <SeqBlock> 
                    | <LabelStmt> 
                    | <GotoStmt> 
                    | "finish" [ "(" ")" ] ";"            (* End a procedure execution&#8203;:contentReference[oaicite:17]{index=17}&#8203;:contentReference[oaicite:18]{index=18} *)
                    | <FunctionDef> 
                    | <ProcedureDef>
                    (* Any action in the module body: assignments, calls, control structures, labeled/goto, 
                       or function/procedure definitions. Common (unencapsulated) actions execute concurrently&#8203;:contentReference[oaicite:19]{index=19}. *)
 
<Assignment>      ::= <LHSExpr> ( "=" | ":=" ) <Expr> ";" 
                     (* "=" immediate assignment, ":=" registered (next-clock) assignment&#8203;:contentReference[oaicite:20]{index=20} *)
<ProcedureCall>   ::= <Identifier> "(" [ <ArgList> ] ")"   (* Call a procedure by name&#8203;:contentReference[oaicite:21]{index=21} *)
<FuncCall>        ::= [ <Identifier> "." ] <Identifier> "(" [ <ArgList> ] ")" [ "." <Identifier> ] 
                     (* Control function call. With instance prefix = call submodule's func_in&#8203;:contentReference[oaicite:22]{index=22}; 
                        with trailing ".Output" = retrieve a submodule output&#8203;:contentReference[oaicite:23]{index=23}. 
                        If no instance, calling an internal or outgoing function in the same module&#8203;:contentReference[oaicite:24]{index=24}. *)
<ArgList>         ::= <Expr> { "," <Expr> }
 
<IfStmt>          ::= "if" "(" <Expr> ")" <ActionBlock> [ "else" <ActionBlock> ]
                     (* Conditional execution. "else" block is optional&#8203;:contentReference[oaicite:25]{index=25} *)
<AltBlock>        ::= "alt" "{" { <AltBranch> } "}" 
<AltBranch>       ::= [ <Expr> ] ":" <AtomicAction> 
                    | "else" ":" <AtomicAction> 
                    (* Select one of multiple guarded actions (with priority). Conditions appear before ':'; 
                       "else:" handles no-conditions-met case&#8203;:contentReference[oaicite:26]{index=26}&#8203;:contentReference[oaicite:27]{index=27}. *)
<AnyBlock>        ::= "any" "{" { <AltBranch> } "}" 
                     (* Similar to alt, but without priority (nondeterministic selection)&#8203;:contentReference[oaicite:28]{index=28} *)
<ParBlock>        ::= "par" "{" { <ActionStmt> } "}" 
                     (* Execute enclosed actions in parallel (logical grouping) *)
<WhileLoop>       ::= "while" "(" <Expr> ")" "{" { <ActionStmt> } "}"    (* Loop (only inside sequential blocks)&#8203;:contentReference[oaicite:29]{index=29}&#8203;:contentReference[oaicite:30]{index=30} *)
<ForLoop>         ::= "for" "(" <ForInitOpt> ";" <ExprOpt> ";" <ForIterOpt> ")" "{" { <ActionStmt> } "}" 
                     (* For loop (only in seq block)&#8203;:contentReference[oaicite:31]{index=31}&#8203;:contentReference[oaicite:32]{index=32} *)
<ForInitOpt>      ::= [ <AssignmentExpr> | <VarDeclExpr> ]
<ExprOpt>         ::= [ <Expr> ]
<ForIterOpt>      ::= [ <AssignmentExpr> | <UnaryExpr> ]   (* e.g., i++ or i += ... *)
 
<SeqBlock>        ::= "seq" "{" { <ActionStmt> } "}" 
                     (* Denotes sequential (ordered) execution region&#8203;:contentReference[oaicite:33]{index=33}&#8203;:contentReference[oaicite:34]{index=34}. 
                        Used within a function or procedure to describe multi-cycle behavior. *)
<LabelStmt>       ::= <Identifier> ":"                     (* Label (for goto) declared inside a seq block&#8203;:contentReference[oaicite:35]{index=35}&#8203;:contentReference[oaicite:36]{index=36} *)
<GotoStmt>        ::= "goto" <Identifier> ";"             (* Jump to label or state&#8203;:contentReference[oaicite:37]{index=37} *)
 
<FunctionDef>     ::= "function" <Identifier> "{" { <ActionStmt> } "}" 
                     (* Define behavior of a control function (for a corresponding func_in or func_self)&#8203;:contentReference[oaicite:38]{index=38} *)
<ProcedureDef>    ::= "proc" <Identifier> [ "seq" ] "{" { <ActionStmt> } "}" 
                     (* Define a procedure’s behavior, optionally sequential (seq)&#8203;:contentReference[oaicite:39]{index=39}&#8203;:contentReference[oaicite:40]{index=40} *)
 
<AtomicAction>    ::= <Assignment> | <ProcedureCall> ";" | <FuncCall> ";" | <GotoStmt> | <LabelStmt> | <finishStmt>
                     (* Single action within alt/any branches or other contexts (may be a single statement or a labeled/goto). *)
<finishStmt>      ::= "finish" [ "(" ")" ] ";"
 
<Expr>            ::= <CondExpr>
<CondExpr>        ::= <OrExpr> [ "if" "(" <OrExpr> ")" <CondExpr> "else" <CondExpr> ] 
                     (* Ternary conditional expression, using if/else syntax&#8203;:contentReference[oaicite:41]{index=41}&#8203;:contentReference[oaicite:42]{index=42} *)
<OrExpr>          ::= <AndExpr> { "||" <AndExpr> }        (* Logical OR *)
<AndExpr>         ::= <BitwiseOrExpr> { "&&" <BitwiseOrExpr> }   (* Logical AND *)
<BitwiseOrExpr>   ::= <BitwiseXorExpr> { "|" <BitwiseXorExpr> }  (* Bitwise OR *)
<BitwiseXorExpr>  ::= <BitwiseAndExpr> { "^" <BitwiseAndExpr> }  (* Bitwise XOR *)
<BitwiseAndExpr>  ::= <EqExpr> { "&" <EqExpr> }           (* Bitwise AND *)
<EqExpr>          ::= <RelExpr> { ( "==" | "!=" ) <RelExpr> }    (* Equality comparison *)
<RelExpr>         ::= <ShiftExpr> { ( "<" | ">" | "<=" | ">=" ) <ShiftExpr> }   (* Relational compare *)
<ShiftExpr>       ::= <AddExpr> { ( "<<" | ">>" ) <AddExpr> }     (* Bit shift *)
<AddExpr>         ::= <MulExpr> { ( "+" | "-" ) <MulExpr> }       (* Addition/subtraction *)
<MulExpr>         ::= <UnaryExpr> { ( "*" ) <UnaryExpr> }         (* Multiplication (and possibly division/mod if supported) *)
<UnaryExpr>       ::= [ ( "!" | "~" | "++" | "--" | "-" | "+" ) ] <PrimaryExpr> 
                     (* Unary negation, bitwise NOT, logical NOT, increment/decrement, etc. 
                        ("~" can also combine with "&","|","^" for reduction ops lexically&#8203;:contentReference[oaicite:43]{index=43}) *)
<PrimaryExpr>     ::= <Identifier> 
                    | <Identifier> "[" <Expr> "]"                   (* Bit-index or array access *)
                    | <Identifier> "[" <Expr> ":" <Expr> "]"        (* Bit-range slice *)
                    | "{" <ExprList> "}"                            (* Concatenation of bits&#8203;:contentReference[oaicite:44]{index=44}&#8203;:contentReference[oaicite:45]{index=45} *)
                    | <Number> "{" <Expr> "}"                       (* Replication: repeat <Expr> bit-pattern <Number> times&#8203;:contentReference[oaicite:46]{index=46} *)
                    | <Number> ( "'" [bBoOdDhH] <DigitSeq> )         (* Sized or base-specific literal (e.g., 8'hFF, 0b1010) *)
                    | <Number>                                      (* Unsized decimal literal *)
                    | "0x" <HexDigits>                              (* C-style hex literal, e.g., 0x3F *)
                    | "0b" <BinDigits>                              (* C-style binary literal *)
                    | "0o" <OctDigits>                              (* C-style octal literal *)
                    | "(" <Expr> ")" 
                    | "1'bx" | "1'bX" | "1'bz" | "1'bZ"             (* 1-bit unknown or high-impedance literal if supported *)
                    | "_" <Identifier> "(" <ArgList> ")"            (* System task (e.g., _display(...), _finish(...))&#8203;:contentReference[oaicite:47]{index=47} *)
 
<ExprList>        ::= <Expr> { "," <Expr> }
<ConstExpr>       ::= <Expr>        (* An expression that is constant/synthesizable *)
<ConstExprList>   ::= <ConstExpr> { "," <ConstExpr> }
 
<Identifier>      ::= <Letter> { <Letter> | <Digit> | "_" }
<Number>          ::= <Digit> { <Digit> }
<Letter>          ::= [A-Za-z_] 
<Digit>           ::= [0-9]


```
