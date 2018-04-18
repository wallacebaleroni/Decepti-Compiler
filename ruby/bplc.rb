require_relative 'smc'

class BPLC
  def initialize(smc)
    @smc = smc
  end

  def vamosRodar()
    puts("AUTBOTS, vamos rodar...")
    while(@smc.tamPilhaControle>0)
      val = @smc.topoControle()
      if(val.is_a?(Fixnum))
        @smc.en()
      else
        @smc.ee()
      end
    end
    puts("...cabou")
  end

end