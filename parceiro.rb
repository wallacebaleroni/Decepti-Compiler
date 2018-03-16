require 'parslet' #gem indicada

class Parceiro < Parslet::Parser
  rule(:integer) { match('[0-9]').repeat(1) } #logica do parser para reconhecer apenas numeros
  root(:integer)
end

Parceiro.new.parse("1234") #é aceita pela linguagem
#Parceiro.new.parse("Hello World!!"), nao é aceita e gera um erro caso seja executada