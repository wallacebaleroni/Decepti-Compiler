require_relative '../ruby/optimusparser.rb'
require_relative '../ruby/bumblebee.rb'
require_relative '../ruby/bplc.rb'
require_relative '../ruby/smc.rb'

code = "
proc min(x,y) {
    const x = 5;
    var y = 10;

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