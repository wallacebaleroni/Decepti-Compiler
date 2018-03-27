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
class Parceiro < Parslet::Parser
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

  rule(:sum)        { integer >> op_sum >> expression }
  rule(:mul)        { integer >> op_mul >> expression }
  rule(:sub)        { integer >> op_sub >> expression }
  rule(:div)        { integer >> op_div >> expression }

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
#                    }"           ) # If expression   # NÃO TA FUNCIONANDO = ñ sei pq
Parceiro.new.parse("if (1 < 2) { \n
                      1 > 2 A 1 < 2 O 1 > 3; 1 + 1\n
                    }"           ) # If expression com seq
Parceiro.new.parse("1 > 2 A 1 < 2 O 1 > 3; 1 + 1")


class Parceiro_exemplo < Parslet::Parser
  rule(:space)      { match('\s').repeat(1) }
  rule(:space?)     { space.maybe }

  rule(:integer)    { match('[0-9]').repeat(1) >> space? }

  rule(:op_sum)     { match('[+]') >> space? }

  rule(:sum)        { expression >> op_sum >> expression }

  rule(:expression) { integer | sum }

  root(:expression)
end

#Parceiro_exemplo.new.parse("1 + 1")
