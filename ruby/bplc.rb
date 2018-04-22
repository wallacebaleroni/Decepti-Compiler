require_relative 'smc'

class BPLC

  def vamosRodar(smc)
    trigger = 0
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
        else
          if(trigger == 1)
            smc.ev()
          else
            trigger = 1
            smc.ci()
          end
        end
      elsif(val.nil?)
        smc.cnil()
      end
    end
    puts("...cabou")
  end


end