require 'parslet'
require_relative 'smc'

def roda(smc)
  puts("rodando...")
  while(smc.tamPilhaControle>0)
    val = smc.desempilhaControle()
    if(val.is_a?(Fixnum))
      smc.empilhaValor(val)
    else
      case val
        when '+'
          n1 = smc.desempilhaValor
          n2 = smc.desempilhaValor
          resp = n1 + n2
          smc.empilhaValor(resp)
        when '-'
          n1 = smc.desempilhaValor
          n2 = smc.desempilhaValor
          resp = n1 - n2
          smc.empilhaValor(resp)
        when '*'
          n1 = smc.desempilhaValor
          n2 = smc.desempilhaValor
          resp = n1 * n2
          smc.empilhaValor(resp)
        when '/'
          n1 = smc.desempilhaValor
          n2 = smc.desempilhaValor
          resp = n1 / n2
          smc.empilhaValor(resp)
      end
    end
  end
  puts("...fim")
end

class Bumblebee < Parslet::Transform #transform que aplica operaçoes matematicas com apenas dois termos


  rule(:left => simple(:left), :right => simple(:right), :op => '+'){

    @smc = SMC.new
    @smc.empilhaControle('+')
    @smc.empilhaControle(Integer(left))
    @smc.empilhaControle(Integer(right))
    roda(@smc)
  }

  rule(:left => simple(:left), :right => simple(:right), :op => '-'){

    @smc = SMC.new
    @smc.empilhaControle('-')
    @smc.empilhaControle(Integer(left))
    @smc.empilhaControle(Integer(right))
    roda(@smc)
  }

  rule(:left => simple(:left), :right => simple(:right), :op => '*'){
    @smc = SMC.new
    @smc.empilhaControle('*')
    @smc.empilhaControle(Integer(left))
    @smc.empilhaControle(Integer(right))
    roda(@smc)
  }

  rule(:left => simple(:left), :right => simple(:right), :op => '/'){
    @smc = SMC.new
    @smc.empilhaControle('/')
    @smc.empilhaControle(Integer(left))
    @smc.empilhaControle(Integer(right))
    roda(@smc)
  }

end

=begin
puts("--------------Parsing, Transform & Execucao--------------")
puts(Bumblebee.new.apply(parse("10+5")))
puts(Bumblebee.new.apply(parse("10-5")))
puts(Bumblebee.new.apply(parse("10*5")))
puts(Bumblebee.new.apply(parse("10/5")))
=end

