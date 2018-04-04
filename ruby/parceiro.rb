require 'parslet' #gem indicada

=begin
P1 - 25 e 27/04 - Expressões e comandos.
    Objetivos:
    1-Ambientar-se com a linguagem escolhida e suas ferramentas.
    2-Entender PEG.
    3-Entender SMC.
    4-Implementar BPLC-mark0: (i) O tipo de dados SMC, (ii) operações aritméticas, Booleanas e comandos.
    5-Implementar um parser PEG para operações aritméticas, Booleanas e comandos.
    6-Implementar um compilador de AST PEG para operações aritméticas, Booleanas e comandos para BPLC-mark0.
=end


class ParceiroReborn < Parslet::Parser #5-Implementar um parser PEG para operações aritméticas, Booleanas e comandos.
  # Basics
  rule(:space)      { str("\s").repeat(1) }
  rule(:space?)     { space.maybe }

  rule(:line)       { str("\n").repeat(1) }
  rule(:line?)      { line.maybe }

  rule(:blank)      { (space | line).repeat(1) }
  rule(:blank?)     { blank.maybe }

  rule(:integer)    { match('[0-9]').repeat(1) >> space? }

  rule(:lowcase)    { match('[a-z]').repeat(1) }
  rule(:upcase)     { match('[A-Z]').repeat(1) }
  rule(:word)       { (lowcase | upcase).repeat(1) >> space? }

  rule(:lp)         { match('[(]') >> space? }
  rule(:rp)         { match('[)]') >> space? }

  rule(:lcb)        { match('[{]') >> space? }
  rule(:rcb)        { match('[}]') >> space? }

  rule(:ident)      { word | integer }

  rule(:sum_op)     { str("+") >> space? }
  rule(:mul_op)     { str("*") >> space? }
  rule(:sub_op)     { str("-") >> space? }
  rule(:div_op)     { str("/") >> space? }
  rule(:cho_op)     { str("|") >> space? }

  rule(:neg_op)     { str("~") >> space? }
  rule(:eq_op)      { str("==") >> space? }
  rule(:lt_op)      { str("<") >> space? }
  rule(:lteq_op)    { str("<=") >> space? }
  rule(:gt_op)      { str(">") >> space? }
  rule(:gteq_op)    { str(">=") >> space? }

  rule(:com_op)     { str(",") >> space? }
  rule(:ini_op)     { str('=') >> space? }
  rule(:ass_op)     { str(":=") >> space? }

  rule(:module_op)  { str("module") >> space? }
  rule(:end_op)     { str("end") >> space? }
  rule(:var_op)     { str("var") >> space? }
  rule(:const_op)   { str("const") >> space? }
  rule(:init_op)    { str("init") >> space? }
  rule(:proc_op)    { str("proc") >> space? }
  rule(:if_op)      { str("if") >> space? }
  rule(:else_op)    { str("else") >> space? }
  rule(:while_op)   { str("while") >> space? }
  rule(:print_op)   { str("print") >> space? }
  rule(:exit_op)    { str("exit") >> space? }

  # IMP Syntax
  rule(:program)    { module_op >> ident >> clauses >> end_op }
  rule(:clauses)    { var.maybe >> const.maybe >> init.maybe >> ex_proc >> (( com_op >> ex_proc ).repeat(1)).maybe } # 3 primeiros termos parecem errados pra mim, mas não entendi o +
  rule(:var)        { var_op >> ident >> (( com_op >> ident ).repeat(1)).maybe }
  rule(:const)      { const_op >> ident >> (( com_op >> ident ).repeat(1)).maybe }
  rule(:init)       { init_op >> ini >> (( com_op >> ini ).repeat(1)).maybe }
  rule(:ini)        { ident >> ini_op >> exp }
  rule(:ex_proc)    { proc_op >> ident >> lp >> ( ident >> (( com_op >> ident ).repeat(1)).maybe ).maybe >> rp >> block }
  rule(:block)      { lcb >> cmd >> (( com_op >> cmd ).repeat(1)).maybe >> rcb }
  rule(:cmd)        { ident >> ass_op >> exp | ex_if | ex_while | ex_print | ex_exit | call | seq | choice }
  rule(:ex_if)      { if_op >> boolexp >> cmd >> else_op >> cmd | if_op >> boolexp >> cmd >> else_op >> block | if_op >> boolexp >> block >> else_op >> cmd | if_op >> boolexp >> block >> else_op >> block }
  rule(:ex_while)   { while_op >> boolexp >> block }
  rule(:ex_print)   { print_op >> lp >> exp >> rp }
  rule(:ex_exit)    { exit_op >> lp >> exp >> rp }
  rule(:call)       { ident >> lp >> exp.maybe >> rp }
  rule(:seq)        { cmd >> com_op >> cmd }
  rule(:choice)     { cmd >> cho_op >> cmd }
  rule(:exp)        { ident | ident >> arithop >> ident | boolexp }
  rule(:arithop)    { sum_op | sub_op | mul_op | cho_op | div_op }
  rule(:boolexp)    { ident >> boolop >> ident }
  rule(:boolop)     { neg_op | eq_op | lt_op | lteq_op | gt_op | gteq_op }

  root(:var)
end

ParceiroReborn.new.parse("var top, to, fa, f");

