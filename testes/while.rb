require_relative '../ruby/optimusparser.rb'
require_relative '../ruby/bumblebee.rb'
require_relative '../ruby/bplc.rb'
require_relative '../ruby/smc.rb'


$smc = SMC.new
bplc = BPLC.new

puts  ("Código:
    proc wh(x) {
        x := 2;
        y := 1;
    
        while (~y == 4) do {
            x := 2 * x;
            y := y + 1
        };
    
        print(x-6)
    }
\n\n")

Bumblebee.new.apply(OptimusParser.new.rollOut("
proc wh(x) {
    x := 2;
    y := 1;

    while (~y == 4) do {
        x := 2 * x;
        y := y + 1
    };

    print(x-6)
}
\n\n")).eval
bplc.vamosRodar($smc)