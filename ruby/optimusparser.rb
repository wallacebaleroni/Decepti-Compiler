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

  rule(:integer)    { match('[0-9]').repeat(1).as(:int) >> blank? }

  rule(:lowcase)    { match('[a-z]').repeat(1) }
  rule(:upcase)     { match('[A-Z]').repeat(1) }
  rule(:word)       { (lowcase | upcase).repeat(1) >> blank? }

  rule(:lp)         { match('[(]') >> blank? }
  rule(:rp)         { match('[)]') >> blank? }

  rule(:lcb)        { match('[{]') >> blank? }
  rule(:rcb)        { match('[}]') >> blank? }

  rule(:ident)      { (lowcase | upcase).repeat(1).as(:id) >> ((lowcase | upcase | integer).repeat(1)).maybe >> blank? }

  rule(:sum_op)     { str("+").as(:op) >> blank? }
  rule(:mul_op)     { str("*").as(:op) >> blank? }
  rule(:sub_op)     { str("-").as(:op) >> blank? }
  rule(:div_op)     { str("/").as(:op) >> blank? }
  rule(:cho_op)     { str("|").as(:op) >> blank? }

  rule(:neg_op)     { str("~").as(:neg) >> blank? }
  rule(:eq_op)      { str("==").as(:opb) >> blank? }
  rule(:lt_op)      { str("<").as(:opb) >> blank? }
  rule(:lteq_op)    { str("<=").as(:opb) >> blank? }
  rule(:gt_op)      { str(">").as(:opb) >> blank? }
  rule(:gteq_op)    { str(">=").as(:opb) >> blank? }

  rule(:seq_op)     { str(";") >> blank? }
  rule(:com_op)     { str(",") >> blank? }
  rule(:ini_op)     { str('=') >> blank? }
  rule(:ass_op)     { str(":=").as(:ass_op) >> blank? }

  rule(:module_op)  { blank? >> str("module") >> blank? }
  rule(:end_op)     { str("end") >> blank? }
  rule(:var_op)     { str("var") >> blank? }
  rule(:const_op)   { str("const") >> blank? }
  rule(:init_op)    { str("init") >> blank? }
  rule(:proc_op)    { blank? >> str("proc") >> blank? }
  rule(:if_op)      { str("if").as(:if) >> blank? }
  rule(:else_op)    { str("else").as(:else) >> blank? }
  rule(:while_op)   { str("while").as(:while) >> blank? }
  rule(:do_op)      { str("do") >> blank? }
  rule(:print_op)   { str("print").as(:print) >> blank? }
  rule(:exit_op)    { str("exit") >> blank? }

  # IMP Syntax
  rule(:program)    { module_op >> ident >> clauses >> end_op }
  rule(:clauses)    { ((var | const | init).repeat(1)).maybe >> ex_proc >> (( com_op >> ex_proc ).repeat(1)).maybe }
  rule(:var)        { var_op >> ident >> (com_op >> ident).repeat(0) }
  rule(:const)      { const_op >> ident >> (com_op >> ident).repeat(1) }
  rule(:init)       { init_op >> ini >> (( com_op >> ini ).repeat(1)).maybe }
  rule(:ini)        { ident >> ini_op >> exp }
  rule(:ex_proc)    { proc_op >> ident.as(:proc) >> lp >> (ident >> (com_op >> ident).repeat(0)).maybe.as(:parametros) >> rp >> block.as(:block) }
  rule(:block)      { lcb >> cmd >> rcb }
  rule(:cmd)        { (cmd_unt >> cho_op >> cmd | cmd_unt.as(:seq1) >> seq_op >> cmd.as(:seq2) | cmd_unt) }
  rule(:cmd_unt)    { ex_if | ex_while | ex_print | ex_exit | call | ident.as(:ident) >> ass_op >> exp.as(:val) }
  rule(:ex_if)      { if_op >> lp >> boolexp.as(:cond) >> rp >> block.as(:block) >> (else_op >> block.as(:blockelse)).maybe |
                      if_op >> lp >> boolexp.as(:cond) >> rp >> cmd.as(:block)   >> (else_op >> block.as(:blockelse)).maybe |
                      if_op >> lp >> boolexp.as(:cond) >> rp >> block.as(:block) >> (else_op >> cmd.as(:blockelse)).maybe |
                      if_op >> lp >> boolexp.as(:cond) >> rp >> cmd.as(:block)   >> (else_op >> cmd.as(:blockelse)).maybe }
  rule(:ex_while)   { while_op >> lp >> boolexp.as(:cond) >> rp >> do_op >> block.as(:block)}
  rule(:ex_print)   { print_op >> lp >> exp.as(:arg) >> rp }
  rule(:ex_exit)    { exit_op >> lp >> exp >> rp }
  rule(:call)       { ident >> lp >> exp.maybe >> rp }
  rule(:exp)        { mathexp | boolexp | integer | ident }
  rule(:mathexp)    { (ident | integer).as(:left) >> arithop >> (mathexp | ident | integer).as(:right) }
  rule(:arithop)    { sum_op | sub_op | mul_op | cho_op | div_op }
  rule(:boolexp)    { neg_op.maybe >>  ((ident | integer).as(:leftb) >> boolop >> exp.as(:rightb)).as(:bool) }
  rule(:boolop)     { eq_op | lteq_op | lt_op | gteq_op | gt_op }

  root(:ex_proc)

  def rollOut(str)
    pp OptimusParser.new.parse(str)
  rescue Parslet::ParseFailed => failure
    puts failure.parse_failure_cause.ascii_tree
  end
end
