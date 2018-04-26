require_relative 'smc'


class BPLC
  def vamosRodar(smc)
    puts("Autobots, let's roll!")
    while(smc.tamPilhaControle > 0)
      val = smc.desempilhaControle()
      if(val.is_a?(Fixnum))
        smc.en()
      elsif(val.is_a?(String))
        if(val == 'assign')
          smc.ce()
        elsif(val == 'print')
          smc.print()
        elsif(val == 'mul' or val == 'div' or val == 'add' or val == 'sub')
          smc.ee()
        elsif(val == 'eq' or val == 'gt' or val == 'ge' or val == 'lt' or val == 'le')
          smc.be()
        elsif(val == 'true' or val == 'false')
          smc.bt()
        elsif(val == 'neg')
          smc.bnote()
        elsif(val == 'loop')
          smc.cwhilee()
        elsif(val == 'if')
          smc.cife()
        elsif(val == 'fimloop'or val == 'fimif' or val =='fimelse')
          smc.cnil()
        elsif(val == ';')
          smc.csc()
        else
          smc.en()
        end
      else
          puts(val)
          val.eval()
      end
    puts("THE END")
    end
  end
end

=begin
if(val.is_a?(Fixnum))
        smc.en()
      elsif(val.is_a?(String))
        if(val == 'assign')
          smc.ce()
        elsif(val == 'print')
          smc.print()
        elsif(val == 'mul' or val == 'div' or val == 'add' or val == 'sub')
          smc.ee()
        elsif(val == 'eq' or val == 'gt' or val == 'ge' or val == 'lt' or val == 'le')
          smc.be()
        elsif(val == 'true' or val == 'false')
          smc.bt()
        elsif(val == 'neg')
          smc.bnote()
        elsif(val == 'loop')
          smc.cwhilee()
        elsif(val == 'if')
          smc.cife()
        elsif(val == 'fimloop'or val == 'fimif' or val =='fimelse')
          smc.cnil()
        elsif(val == ';')
          smc.csc()
        else
          smc.ci_ev()
        end
      elsif(val.nil?)
        smc.cnil()
      end
=end