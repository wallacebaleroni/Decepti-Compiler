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

# Math and boolean expressions
class Parceiro < Parslet::Parser #5-Implementar um parser PEG para operações aritméticas, Booleanas e comandos.
  # Basics
  rule(:space)      { match('\s').repeat(1) }
  rule(:space?)     { space.maybe }

  rule(:line)       { match('\n').repeat(1) }
  rule(:line?)      { line.maybe }

  rule(:blank)      { (space | line).repeat(1) }
  rule(:blank?)     { blank.maybe }

  rule(:integer)    { match('[0-9]').repeat(1) >> space? }

  rule(:lowcase)    { match('[a-z]').repeat(1) }
  rule(:upcase)     { match('[A-Z]').repeat(1) }
  rule(:identifier) { (lowcase | upcase).repeat(1) >> space? }

  # Math expressions
  rule(:op_sum)     { match('[+]') >> space? }
  rule(:op_mul)     { match('[*]') >> space? }
  rule(:op_sub)     { match('[-]') >> space? }
  rule(:op_div)     { match('[/]') >> space? }

  rule(:sum)        { integer.as(:left) >> op_sum.as(:op) >> expression.as(:right) }
  rule(:mul)        { integer.as(:left) >> op_mul.as(:op) >> expression.as(:right) }
  rule(:sub)        { integer.as(:left) >> op_sub.as(:op) >> expression.as(:right) }
  rule(:div)        { integer.as(:left) >> op_div.as(:op) >> expression.as(:right) }

  rule(:ex_math)    { sum | mul | sub | div | integer }


  # Boolean expressions
  rule(:op_eq)      { match('[=]').repeat(2,2) >> space? }
  rule(:op_gt)      { match('[>]') >> space? }
  rule(:op_lt)      { match('[<]') >> space? }
  rule(:op_gteq)    { match('[>]') >> match('[=]') >> space? }
  rule(:op_lteq)    { match('[<]') >> match('[=]') >> space? }

  rule(:eq)         { integer >> op_eq >> integer }
  rule(:gt)         { integer >> op_gt >> integer }
  rule(:lt)         { integer >> op_lt >> integer }
  rule(:gteq)       { integer >> op_gteq >> integer }
  rule(:lteq)       { integer >> op_lteq >> integer }

  rule(:op_neg)     { match('[!]') }
  rule(:lp)         { match('[(]') >> space? }
  rule(:rp)         { match('[)]') >> space? }

  rule(:pos_rel)    { eq | gt | lt | gteq | lteq }
  rule(:neg_rel)    { op_neg >> lp >> pos_rel >> rp }

  rule(:relational) { pos_rel | neg_rel }

  rule(:op_and)     { match('[A]') >> space? }
  rule(:op_or)      { match('[O]') >> space? }

  rule(:ex_and)     { op_and >> ex_bool }
  rule(:ex_or)      { op_or >> ex_bool }
  
  rule(:logic)      { ex_and | ex_or }

  rule(:ex_bool)    { relational >> logic.maybe }

  rule(:expression) { ex_bool | ex_math }


  # Commands
  rule(:op_asgn)    { str(":=") >> space? }
  rule(:ex_asgn)    { identifier >> op_asgn >> expression }

  rule(:lcb)        { match('[{]') >> space? }
  rule(:rcb)        { match('[}]') >> space? }
  rule(:block)      { lcb >> blank? >> body >> blank? >> rcb } # Arranjar um jeito de ser sequencia ou expression

  rule(:op_if)      { str("if") >> space? }
  rule(:ex_if)      { op_if >> lp >> ex_bool >> rp >> block }

  rule(:op_sep)     { match('[;]') >> space? }
  rule(:ex_seq)     { inner_body >> op_sep >> inner_body.repeat(1) }

  rule(:command)    { ex_asgn | ex_if | ex_seq }

  rule(:inner_body) { ex_asgn | expression }


  # Root
  rule(:body)       { command | expression }
  
  root(:body)
end

=begin
def parse(str) #pro erro vir "bonitinho"
  parca = Parceiro.new

  parca.parse(str)
rescue Parslet::ParseFailed => failure
  puts failure.parse_failure_cause.ascii_tree
end
require 'pp' #pro print vir "bonitinho"
pp Parceiro.new.parse("10-10-10-10")
=end


class OptimusPrime < Parslet::Transform #transform que aplica operaçoes matematicas, op com mais de um elemento e q a ordem influencia nao funcionam direito
  rule(:left => simple(:left), :right => simple(:right), :op => '+'){
    resp = Integer(left) + Integer(right)
    resp
  }
  rule(:left => simple(:left), :right => simple(:right), :op => '-'){
    resp = Integer(left) - Integer(right)
    resp
  }
  rule(:left => simple(:left), :right => simple(:right), :op => '*'){
    resp = Integer(left) * Integer(right)
    resp
  }
  rule(:left => simple(:left), :right => simple(:right), :op => '/'){
    resp = Integer(left) / Integer(right)
    resp
  }
end


puts(OptimusPrime.new.apply(Parceiro.new.parse("10+5")))
puts(OptimusPrime.new.apply(Parceiro.new.parse("10-5")))
puts(OptimusPrime.new.apply(Parceiro.new.parse("10*5")))
puts(OptimusPrime.new.apply(Parceiro.new.parse("10/5")))


=begin Testes de unidade
Parceiro.new.parse("1 + 3") # Math expression
Parceiro.new.parse("1 - 3") # Math expression
Parceiro.new.parse("1 * 3") # Math expression
Parceiro.new.parse("1 / 3") # Math expression
Parceiro.new.parse("1 + 3 - 2 * 3 / 4") # Math expression
Parceiro.new.parse("1 > 2") # Bool expression
Parceiro.new.parse("1 >= 2") # Bool expression
Parceiro.new.parse("1 < 2") # Bool expression
Parceiro.new.parse("1 <= 2") # Bool expression
Parceiro.new.parse("1 == 2") # Bool expression
Parceiro.new.parse("1 > 2 A 1 < 2 O 1 > 3") # Bool and math expression
Parceiro.new.parse("!(1 > 2) A 1 < 2 O !(1 > 3)") # Bool and math expression with negation
Parceiro.new.parse("if (1 > 2) {\n
                      1 + 1     \n
                    }"          ) # If expression
Parceiro.new.parse("gg := 1 + 1")
#Parceiro.new.parse("if (1 > 2) { \n
#                      gg := 1 + 1 ; 1 + 1\n
#                    }"           ) # If expression   # NÃO TA FUNCIONANDO = ñ sei pq, era pra funcionar pelo fluxo
Parceiro.new.parse("if (1 < 2) { \n
                      1 > 2 A 1 < 2 O 1 > 3; 1 + 1\n
                    }"           ) # If expression com seq
Parceiro.new.parse("1 > 2 A 1 < 2 O 1 > 3; 1 + 1")
=end



=begin Exemplo
class Parceiro_exemplo < Parslet::Parser
  rule(:space)      { match('\s').repeat(1) }
  rule(:space?)     { space.maybe }

  rule(:integer)    { match('[0-9]').repeat(1) >> space? }

  rule(:op_sum)     { match('[+]') >> space? }

  rule(:sum)        { expression >> op_sum >> expression }

  rule(:expression) { integer | sum }

  root(:expression)
end
=end



class ParceiroReborn < Parslet::Parser
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
