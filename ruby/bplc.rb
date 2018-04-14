require_relative 'smc'

class BPLC
  def initialize(smc)
    @smc = smc
  end

  def roda()
    puts("rodando...")
    while(@smc.tamPilhaControle>0)
      val = @smc.desempilhaControle()
      if(val.is_a?(Fixnum))
        @smc.empilhaValor(val)
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

end