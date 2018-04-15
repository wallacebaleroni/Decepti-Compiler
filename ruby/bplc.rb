require_relative 'smc'

class BPLC
  def initialize(smc)
    @smc = smc
  end

  def roda()
    puts("rodando...")
    while(@smc.tamPilhaControle>0)
      val = @smc.topoControle()
      if(val.is_a?(Fixnum))
        @smc.en()
      else
        @smc.ee()
      end
    end
    puts("...fim")
  end

end