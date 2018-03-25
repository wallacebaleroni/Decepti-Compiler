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

class Parceiro < Parslet::Parser #Objetivo 5 Expressoes aritiméticas
  rule(:space)      { match('\s').repeat(1) }
  rule(:space?)     { space.maybe }

  rule(:integer)    { match('[0-9]').repeat(1) >> space? }

  rule(:op_sum)     { match('[+]') >> space? }
  rule(:op_mul)     { match('[*]') >> space? }
  rule(:op_sub)     { match('[-]') >> space? }
  rule(:op_div)     { match('[/]') >> space? }

  rule(:sum)        { integer >> op_sum >> expression }
  rule(:mul)        { integer >> op_mul >> expression }
  rule(:sub)        { integer >> op_sub >> expression }
  rule(:div)        { integer >> op_div >> expression }

  rule(:expression) { sum | mul | sub | div | integer }

  root(:expression)
end

Parceiro.new.parse("1 + 3") #é aceita pela linguagem
Parceiro.new.parse("1 - 3") #é aceita pela linguagem
Parceiro.new.parse("1 * 3") #é aceita pela linguagem
Parceiro.new.parse("1 / 3") #é aceita pela linguagem
Parceiro.new.parse("1 + 3 - 2 * 3 / 4") #é aceita pela linguagem


class Parceiro2 < Parslet::Parser #Objetivo 5 Expressoes booleanas com inteiros, falta só reconhecer a negação
  rule(:space)      { match('\s').repeat(1) }
  rule(:space?)     { space.maybe }

  rule(:integer)    { match('[0-9]').repeat(1) >> space? }


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
  rule(:relational) { eq | gt | lt | gteq | lteq }


  rule(:op_and)     { match('[A]') >> space? }
  rule(:op_or)      { match('[O]') >> space? }

  rule(:ex_and)     { op_and >> expression }
  rule(:ex_or)      { op_or >> expression }
  rule(:logic)      { ex_and | ex_or }


  rule(:expression) { relational >> logic.maybe }


  rule(:op_neg)     { match('[!]') }
  rule(:lp)         { match('[(]') >> space? }
  rule(:rp)         { match('[)]') >> space? }
  
  rule(:neg)        { op_neg >> lp >> expression >> rp }

  rule(:root)       { expression | neg }

  root(:neg)
end


#Parceiro2.new.parse("1 > 2")
#Parceiro2.new.parse("1 >= 2")
#Parceiro2.new.parse("1 < 2")
#Parceiro2.new.parse("1 <= 2")
#Parceiro2.new.parse("1 == 2")
Parceiro2.new.parse("!(1 > 2 A 1 < 2 A 1 > 3)")

class Parceiro3 < Parslet::Parser 
  rule(:space)      { match('\s').repeat(1) }
  rule(:space?)     { space.maybe }

  rule(:integer)    { match('[0-9]').repeat(1) >> space? }

  rule(:op_sum)     { match('[+]') >> space? }

  rule(:sum)        { expression >> op_sum >> expression }

  rule(:expression) { integer | sum }

  root(:expression)
end

#Parceiro3.new.parse("1 + 1")