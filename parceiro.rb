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

class Parceiro < Parslet::Parser
  rule(:integer)    { match('[0-9]').repeat(1) >> space? }

  rule(:space)      { match('\s').repeat(1) }
  rule(:space?)     { space.maybe }

  rule(:oSum)   { match('[+]') >> space? }
  rule(:oMul)   { match('[*]') >> space? }
  rule(:oSub)   { match('[-]') >> space? }
  rule(:oDiv)   { match('[/]') >> space? }

  rule(:sum)  { integer >> oSum >> expression }
  rule(:mul)  { integer >> oMul >> expression }
  rule(:sub)  { integer >> oSub >> expression }
  rule(:div)  { integer >> oDiv >> expression }

  rule(:expression) { sum | mul | sub | div | integer }

  root(:expression)
end

=begin
TESTES
Parceiro.new.parse("1 + 3") #é aceita pela linguagem
Parceiro.new.parse("1 - 3") #é aceita pela linguagem
Parceiro.new.parse("1 * 3") #é aceita pela linguagem
Parceiro.new.parse("1 / 3") #é aceita pela linguagem
Parceiro.new.parse("1 + 3 - 2 * 3 / 4") #é aceita pela linguagem
=end
