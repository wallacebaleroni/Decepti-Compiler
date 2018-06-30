require_relative 'optimusparser'
require_relative 'bumblebee'
require_relative 'bplc'
require_relative 'smc'


$smc = SMC.new
bplc = BPLC.new

code = "
module modtop
  proc fact(x) {
    var x = 5;
    var y = 1;
    const w = 1

    while (x > 0) do {
        y := y * x;
        x := x - w
    };

    print(y)
  }

  proc top(x) {
    var x = 5

    if (x > 0) {
        print(x)
    }
  }

  fact(x)
  top(x)
end"

puts code
puts

$smc = SMC.new
bplc = BPLC.new
Bumblebee.new.apply(OptimusParser.new.rollOut(code))
bplc.vamosRodar()
