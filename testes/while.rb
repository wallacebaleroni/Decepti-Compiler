require_relative '../ruby/optimusparser.rb'
require_relative '../ruby/bumblebee.rb'
require_relative '../ruby/bplc.rb'
require_relative '../ruby/smc.rb'

code = "
proc wh(x) {
    var x = 2;
    var y = 1

    while (~ y == 3) do {
        x := 2 * x;
        y := y + 1
    };

    print(x)
}"

$smc = SMC.new
bplc = BPLC.new
Bumblebee.new.apply(OptimusParser.new.rollOut(code))
bplc.vamosRodar()