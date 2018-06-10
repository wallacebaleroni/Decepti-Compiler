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

  rule(:ident)      { (lowcase | upcase).repeat(1).as(:ident) >> ((lowcase | upcase | integer).repeat(1)).maybe >> blank? }

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
  rule(:ini_op)     { str('=').as(:ini_op) >> blank? }
  rule(:ass_op)     { str(":=").as(:ass_op) >> blank? }

  rule(:module_op)  { blank? >> str("module") >> blank? }
  rule(:end_op)     { str("end") >> blank? }

  # rule(:init_op)    { str("init").as(:init) >> blank? }

  rule(:var_op)     { str("var").as(:decl_op) >> blank? }
  rule(:const_op)   { str("const").as(:decl_op) >> blank? }
  rule(:decl_op)    { var_op | const_op }
  rule(:ini_op)     { str("=") >> blank? }

  rule(:proc_op)    { blank? >> str("proc") >> blank? }
  rule(:if_op)      { str("if").as(:if) >> blank? }
  rule(:else_op)    { str("else").as(:else) >> blank? }
  rule(:while_op)   { str("while").as(:while) >> blank? }
  rule(:do_op)      { str("do") >> blank? }
  rule(:print_op)   { str("print").as(:print) >> blank? }
  rule(:exit_op)    { str("exit") >> blank? }

  # IMP Syntax
  rule(:program)    { module_op >> ident.as(:module) >> clauses.as(:clauses) >> end_op }
  rule(:clauses)    { decl_seq >> ex_proc }

  rule(:decl_seq)   { decl.as(:decl_seq1) >> seq_op >> decl_seq.as(:decl_seq2) | decl }
  rule(:decl)       { decl_op >> ini_seq.as(:ini) }
  rule(:ini_seq)    { ini.as(:ini_seq1) >> com_op >> ini_seq.as(:ini_seq2) | ini }
  rule(:ini)        { ident >> ini_op >> exp.as(:val) }

  rule(:ex_proc)    { proc_op >> ident.as(:proc) >> lp >> (ident >> (com_op >> ident).repeat(0)).maybe.as(:parametros) >> rp >> block.as(:block) }
  rule(:block)      { lcb >> decl_seq >> cmd >> rcb }
  rule(:cmd)        { (cmd_unt >> cho_op >> cmd | cmd_unt.as(:seq1) >> seq_op >> cmd.as(:seq2) | cmd_unt) }
  rule(:cmd_unt)    { ex_if | ex_while | ex_print | decl_seq | ex_exit | call | ident.as(:ident) >> ass_op >> exp.as(:val) }
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
  rule(:boolexp)    { yboolexp | nboolexp }
  rule(:yboolexp)   { ((ident | integer).as(:leftb) >> boolop >> exp.as(:rightb)) }
  rule(:nboolexp)   { neg_op >> yboolexp.as(:bool) }
  rule(:boolop)     { eq_op | lteq_op | lt_op | gteq_op | gt_op }

  root(:ex_proc)

  def rollOut(str)
    pp OptimusParser.new.parse(str)
  rescue Parslet::ParseFailed => failure
    puts failure.parse_failure_cause.ascii_tree
  end
end
