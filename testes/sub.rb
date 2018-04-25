require_relative '../ruby/optimusparser.rb'
require_relative '../ruby/bumblebee.rb'
require_relative '../ruby/bplc.rb'
require_relative '../ruby/smc.rb'


$smc = SMC.new
bplc = BPLC.new

puts  ("Código:
    proc sub(x) {
        x := 15;
        y := 5;
        print(x-y)
    }
    }
}\n\n")

Bumblebee.new.apply(OptimusParser.new.rollOut("
proc sub(x) {
    x := 15;
    y := 5;
    print(x-y)
}
\n\n")).eval
bplc.vamosRodar($smc)