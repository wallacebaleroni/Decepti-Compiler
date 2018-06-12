require_relative '../ruby/optimusparser.rb'
require_relative '../ruby/bumblebee.rb'
require_relative '../ruby/bplc.rb'
require_relative '../ruby/smc.rb'

code = "
proc mul(x) {
    var x = 1;
    const y = 5

    x := 2 * x;
    print(x * y * y)
}"

puts code

$smc = SMC.new
bplc = BPLC.new
Bumblebee.new.apply(OptimusParser.new.rollOut(code))
bplc.vamosRodar()