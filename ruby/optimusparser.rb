
require 'parslet'
require 'pp'


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

  rule(:ident)      { (lowcase | upcase).repeat(1).as(:id) >> ((lowcase | upcase | integer).repeat(1)).maybe >> space? }

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
  rule(:do_op)      { str("do") >> space? }
  rule(:print_op)   { str("print") >> space? }
  rule(:exit_op)    { str("exit") >> space? }

  # IMP Syntax
  rule(:program)    { blank? >> module_op >> ident >> blank? >> clauses >> blank? >> end_op }
  rule(:clauses)    { ((var | const | init).repeat(1)).maybe >> ex_proc >> (( com_op >> ex_proc ).repeat(1)).maybe }
  rule(:var)        { var_op >> ident >> (com_op >> ident).repeat(0) >> blank? }
  rule(:const)      { const_op >> ident >> (com_op >> ident).repeat(1) >> blank? }
  rule(:init)       { init_op >> ini >> (( com_op >> ini ).repeat(1)).maybe >> blank? }
  rule(:ini)        { ident >> ini_op >> exp }
  rule(:ex_proc)    { proc_op. >> ident.as(:proc) >> lp >> (ident >> (com_op >> ident).repeat(0)).maybe.as(:parametros) >> rp >> block.as(:block) }
  rule(:block)      { lcb >> blank? >> cmd >> rcb >> blank? }
  rule(:cmd)        { (cmd_unt >> cho_op >> cmd | cmd_unt.as(:seq1) >> seq_op >> cmd.as(:seq2) | cmd_unt.as(:cmd)) >> blank? }
  rule(:cmd_unt)    { ex_if | ex_while | ex_print | ex_exit | call | ident.as(:ident) >> ass_op.as(:ass_op) >> exp.as(:val) }
  rule(:ex_if)      { if_op.as(:if) >> lp >> boolexp.as(:cond) >> rp >> block.as(:block) >> (else_op >> block).maybe | if_op >> lp >> boolexp >> rp >> cmd >> (else_op >> block).maybe | if_op >> lp >> boolexp >> rp >> block >> (else_op >> cmd).maybe | if_op >> lp >> boolexp >> rp >> cmd >> (else_op >> cmd).maybe }
  rule(:ex_while)   { while_op.as(:while) >> lp >> boolexp.as(:cond) >> rp >> do_op >> block.as(:block)}
  rule(:ex_print)   { print_op.as(:print) >> lp >> exp.as(:arg) >> rp }
  rule(:ex_exit)    { exit_op >> lp >> exp >> rp }
  rule(:call)       { ident >> lp >> exp.maybe >> rp }
  rule(:exp)        { mathexp | boolexp | integer | ident }
  rule(:mathexp)    { (ident | integer).as(:left) >> arithop.as(:op) >> (mathexp | ident | integer).as(:right) }
  rule(:arithop)    { sum_op | sub_op | mul_op | cho_op | div_op }
  rule(:boolexp)    { neg_op.as(:neg).maybe >>  (ident | integer).as(:leftb) >> boolop.as(:opb) >> exp.as(:rightb) }
  rule(:boolop)     { eq_op | lteq_op | lt_op | gteq_op | gt_op }

  root(:ex_proc)

  def rollOut(str)
    pp OptimusParser.new.parse(str)
  rescue Parslet::ParseFailed => failure
    puts failure.parse_failure_cause.ascii_tree
  end

end

=begin
# Fatorial
OptimusParser.new.rollOut("
module Fact
  var y
  init y = 1
  proc fact(x) {
    while (~ x == 0) do {
      y := y * x ; x := x - 1
    } ; print(y)
  }
end");
=end
