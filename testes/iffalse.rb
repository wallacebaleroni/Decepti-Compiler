require_relative '../ruby/optimusparser.rb'
require_relative '../ruby/bumblebee.rb'
require_relative '../ruby/bplc.rb'
require_relative '../ruby/smc.rb'

code = "
proc min(x,y) {
    const x = 10;
    var y = 5;

    if (x < y) {
        print(x)
    } else {
        print(y)
    }
}"

puts code

$smc = SMC.new
bplc = BPLC.new
Bumblebee.new.apply(OptimusParser.new.rollOut(code))
bplc.vamosRodar()