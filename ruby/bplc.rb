require_relative 'smc'

class BPLC

  def vamosRodar(smc)
    puts("AUTBOTS, vamos rodar...")
    while(smc.tamPilhaControle>0)
      val = smc.topoControle()
      if(val.is_a?(Fixnum))
        smc.en()
      elsif(val.is_a?(String))
        if(val == 'assign')
          smc.ce()
        elsif(val == 'mul' or val == 'div' or val == 'add' or val == 'sub')
          smc.ee()
        elsif(val == 'eq' or val == 'gt' or val == 'ge' or val == 'lt' or val == 'le')
          smc.be()
        elsif(val == 'true' or val == 'false')
          smc.bt()
        elsif(val == 'neg')
          smc.bnote()
        elsif(val == 'loop')
          smc.desempilhaControle()
        else
          smc.ci_ev() #ou smc.ev()
        end
      elsif(val.nil?)
        smc.cnil()
      end
    end
    puts("...cabou")
  end


end