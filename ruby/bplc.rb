require_relative 'smc'

class BPLC

  def vamosRodar(smc)
    puts("AUTBOTS, vamos rodar...")
    while(smc.tamPilhaControle>0)
      val = smc.topoControle()
      if(val.is_a?(Fixnum))
        smc.en()
      elsif(val.is_a?(String))
        if(val == ':=')
          smc.ce()
        elsif(val == 'mul' or val == 'div' or val == 'add' or val == 'sub')
          smc.ee()
        else
          smc.ci()
        end
      elsif(val.nil?)
        smc.cnil()
      end
    end
    puts("...cabou")
  end


end