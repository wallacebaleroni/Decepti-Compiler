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
  rule(:integer) { match('[0-9]').repeat(1) } #logica do parser para reconhecer apenas numeros
  root(:integer)
end

Parceiro.new.parse("1234") #é aceita pela linguagem
#Parceiro.new.parse("Hello World!!"), nao é aceita e gera um erro caso seja executada