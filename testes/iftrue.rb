require_relative '../ruby/optimusparser.rb'
require_relative '../ruby/bumblebee.rb'
require_relative '../ruby/bplc.rb'
require_relative '../ruby/smc.rb'


$smc = SMC.new
bplc = BPLC.new

puts  ("Código:
    proc min(x) {
        x := 10;
        y := 20;
    
        if (x < y) {
            print(x)
        } else {
            print(y)
        }
    }
\n\n")

Bumblebee.new.apply(OptimusParser.new.rollOut("
proc min(x) {
    x := 10;
    y := 20;

    if (x < y) {
        print(x)
    } else {
        print(y)
    }
}
\n\n")).eval
bplc.vamosRodar($smc)