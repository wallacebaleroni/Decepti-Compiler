require_relative '../ruby/optimusparser.rb'
require_relative '../ruby/bumblebee.rb'
require_relative '../ruby/bplc.rb'
require_relative '../ruby/smc.rb'


$smc = SMC.new
bplc = BPLC.new

puts  ("Código:
    proc add(x) {
        x := 0;
        y := 2;
        print(x+y+y+y+y+y)
    }
\n\n")

Bumblebee.new.apply(OptimusParser.new.rollOut("
proc add(x) {
    x := 0;
    y := 2;
    print(x+y+y+y+y+y)
}

  ")).eval
bplc.vamosRodar($smc)