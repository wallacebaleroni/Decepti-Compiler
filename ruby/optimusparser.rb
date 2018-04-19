
require 'parslet' #gem indicada
require 'pp'

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

class OptimusParser < Parslet::Parser
  # Basics
  rule(:space)      { str("\s").repeat(1) }
  rule(:space?)     { space.maybe }

  rule(:line)       { str("\n").repeat(1) }
  rule(:line?)      { line.maybe }

  rule(:tab)        { str("\t").repeat(1) }
  rule(:tab?)       { tab.maybe }

  rule(:blank)      { (space | line | tab).repeat(1) }
  rule(:blank?)     { blank.maybe }

  rule(:integer)    { match('[0-9]').repeat(1).as(:int) >> space? }

  rule(:lowcase)    { match('[a-z]').repeat(1) }
  rule(:upcase)     { match('[A-Z]').repeat(1) }
  rule(:word)       { (lowcase | upcase).repeat(1) >> space? }

  rule(:lp)         { match('[(]') >> space? }
  rule(:rp)         { match('[)]') >> space? }

  rule(:lcb)        { match('[{]') >> space? }
  rule(:rcb)        { match('[}]') >> space? }

  rule(:ident)      { (lowcase | upcase).repeat(1) >> ((lowcase | upcase | integer).repeat(1)).maybe >> space? } # Aceita numeros também no nome

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

  rule(:seq_op)     { str(";") >> space? }
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
  rule(:program)    { module_op >> ident >> blank? >> clauses >> blank? >> end_op }
  rule(:clauses)    { ((var | const | init).repeat(1)).maybe >> ex_proc >> (( com_op >> ex_proc ).repeat(1)).maybe }
  rule(:var)        { var_op >> ident >> (com_op >> ident).repeat(0) >> blank? }
  rule(:const)      { const_op >> ident >> (com_op >> ident).repeat(1) >> blank? }
  rule(:init)       { init_op >> ini >> (( com_op >> ini ).repeat(1)).maybe >> blank? }
  rule(:ini)        { ident >> ini_op >> exp }
  rule(:ex_proc)    { proc_op >> ident >> lp >> (ident >> (com_op >> ident).repeat(0)).maybe >> rp >> block }
  rule(:block)      { lcb >> blank? >> cmd >> rcb >> blank? }
  rule(:cmd)        { (cmd_unt >> cho_op >> cmd | cmd_unt >> seq_op >> cmd | cmd_unt) >> blank? }
  rule(:cmd_unt)    { ex_if | ex_while | ex_print | ex_exit | call | ident >> ass_op >> exp }
  rule(:ex_if)      { if_op >> lp >> boolexp >> rp >> block >> (else_op >> block).maybe | if_op >> lp >> boolexp >> rp >> cmd >> (else_op >> block).maybe | if_op >> lp >> boolexp >> rp >> block >> (else_op >> cmd).maybe | if_op >> lp >> boolexp >> rp >> cmd >> (else_op >> cmd).maybe }
  rule(:ex_while)   { while_op >> lp >> boolexp >> rp >> block }
  rule(:ex_print)   { print_op >> lp >> exp >> rp }
  rule(:ex_exit)    { exit_op >> lp >> exp >> rp }
  rule(:call)       { ident >> lp >> exp.maybe >> rp }
  rule(:exp)        { mathexp | boolexp | integer | ident }
  rule(:mathexp)    { (ident | integer).as(:left) >> (arithop.as(:op) >> mathexp.as(:right)).maybe }
  rule(:arithop)    { sum_op | sub_op | mul_op | cho_op | div_op }
  rule(:boolexp)    { neg_op.maybe >> ((ident | integer) >> (boolop >> boolexp).maybe) }
  rule(:boolop)     { eq_op | lteq_op | lt_op | gteq_op | gt_op }

  root(:mathexp) # para testar expressoes matematicas, alterar root de acordo com teste por enquanto

  def rollOut(str)
    pp OptimusParser.new.parse(str)
  rescue Parslet::ParseFailed => failure
    puts failure.parse_failure_cause.ascii_tree
  end

end

=begin
#OptimusParser.new.parse("1 + 1 + 1")
#OptimusParser.new.parsea("if (1 > 1) { af := 1 } else { af := 1 }");
#OptimusParser.new.parsea("if (1 > 1) { af := 1 + 1 + 1 - 100 * 1 / 3 ; topstermctopper := 1 } else { af := 1 | vlwjoao := 2 }");
#OptimusParser.new.parse("module top var top proc top ( top ) { af := 1 } end"); # :program
#  module_op >> ident >> ((var | const | init).repeat(1)).maybe >> proc_op >> ident >> lp >> ( ident >> (( com_op >> ident ).repeat(1)).maybe ).maybe >> rp >> block >> end_op

OptimusParser.new.rollOut("module Fact var y init y = 1 proc fact(x) { while (~ x == 0) { y := x * y ; x := x > 1 } ; print(y) } end");
OptimusParser.new.rollOut("module Fact
                  var y
                  init y = 1 
                  proc fact(x) { 
                    while (~ x == 0) { 
                      y := x * y ; y := x + 1 
                    } ; print(y) 
                  }
                end");

OptimusParser.new.rollOut("module Fact
                  var y, x
                  init y = 1 
                  proc fact(x) { 
                    if (~ x == 0) { 
                      y := x * y ; y := x + 1 
                    } 
                  }
                end");


OptimusParser.new.rollOut("1+1+1+1")
=end