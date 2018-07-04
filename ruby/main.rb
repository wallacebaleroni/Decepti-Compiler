require_relative 'optimusparser'
require_relative 'bumblebee'
require_relative 'bplc'
require_relative 'smc'


$smc = SMC.new
bplc = BPLC.new

fact_code = "
module modtop
  func fact(x,y) {
    const w = 1

    while (x > 0) do {
      y := y * x;
      x := x - 1
    }

    return y
  }
  fact(2,1)
end"

fact_test_code = "
module modtop
  proc fact(x) {
    var x = 5;
    var y = 1;
    const w = fact(x)

    while (x > 0) do {
      y := y * x;
      x := top(x) - top(x)
    };

    print(y)
  }

  proc top(x) {
    var x = 5

    if (x > 0) {
      print(x)
    }
  }

  fact(2)
  top(x)
end"

test_code = "
module toptop
  proc fact(x) {
    if (x > 0) {
      x := fact(2)
    }
  }
end"

code = fact_code

puts code
puts

$smc = SMC.new
bplc = BPLC.new
Bumblebee.new.apply(OptimusParser.new.rollOut(code))
bplc.vamosRodar()
