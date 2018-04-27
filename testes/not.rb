require_relative '../ruby/optimusparser.rb'
require_relative '../ruby/bumblebee.rb'
require_relative '../ruby/bplc.rb'
require_relative '../ruby/smc.rb'

code = "proc not(x) {
    x := 0;
    y := 2;

    while (~ x == 2 * y) do {
        x := x + 1
    };

    print(x)
}"

$smc = SMC.new
bplc = BPLC.new
Bumblebee.new.apply(OptimusParser.new.rollOut(code))
bplc.vamosRodar($smc)