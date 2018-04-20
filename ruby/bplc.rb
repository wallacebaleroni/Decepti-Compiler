require_relative 'smc'

class BPLC

  def vamosRodar(smc)
    puts("AUTBOTS, vamos rodar...")
    while(smc.tamPilhaControle>0)
      val = smc.topoControle()
      if(val.is_a?(Fixnum))
        smc.en()
      else
        smc.ee()
      end
    end
    puts("...cabou")
  end


end