require_relative '../ruby/optimusparser.rb'
require_relative '../ruby/bumblebee.rb'
require_relative '../ruby/bplc.rb'
require_relative '../ruby/smc.rb'

$smc = SMC.new
bplc = BPLC.new

code = "
proc div(x) {
    x := 100;
    y := 5;
    print(x / y)
}"

puts code

$smc = SMC.new
bplc = BPLC.new
Bumblebee.new.apply(OptimusParser.new.rollOut(code))
bplc.vamosRodar($smc)