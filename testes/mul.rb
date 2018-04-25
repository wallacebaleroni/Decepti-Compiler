require_relative '../ruby/optimusparser.rb'
require_relative '../ruby/bumblebee.rb'
require_relative '../ruby/bplc.rb'
require_relative '../ruby/smc.rb'


$smc = SMC.new
bplc = BPLC.new

puts  ("Código:
    proc mul(x) {
        x := 1;
        x := 2 * x;
        y := 5;
        print(x * y)
    }
\n\n")

Bumblebee.new.apply(OptimusParser.new.rollOut("
proc mul(x) {
    x := 1;
    x := 2 * x;
    y := 5;
    print(x * y)
}
")).eval
bplc.vamosRodar($smc)