require_relative 'optimusparser'
require_relative 'bumblebee'
require_relative 'bplc'
require_relative 'smc'

$debug = true

$smc = SMC.new
bplc = BPLC.new

fact_code = "
module modtop
  func fact(x,y) {
    const w = 1
    while (x > 0) do {
      y := y * x;
      x := x - w
    }

    return y
  }
  fact(5,1)
end"

fact_test_code = "
module modtop
  proc fact(x) {
    var x = 5;
    var y = 1;
    const w = 1122

    while (x > 0) do {
      y := y * x;
      x := top(x) - top(x)
    };

    print(y)
  }

  func top(x) {
    var x = 5

    if (x > 0) {
      print(x)
    }

    return 1
  }

  fact(2)
  top(1)
end"

test_code = "
module toptop
  proc test(x) {
    var y = 1

    if (y == 1) {
      var y = 2
    }
  }

  test(0)
end"

infinite_loop = "
module toptop
  func funcTeste() {
    var y = 1

    y := funcTeste()
  }

  funcTeste()
end
"

rec_code="
module factRecursivo
  func fact(x) {
    var ret = 1

    if (x == 1) {
      ret := 1
    } else {
      ret := x * fact(x - 1)
    }

    return ret
  }

  proc printFact(x) {
    print(fact(x))
  }

  printFact(5)

end"

code = rec_code

if $debug
  puts code
  puts
end

$smc = SMC.new
bplc = BPLC.new
Bumblebee.new.apply(OptimusParser.new.rollOut(code))
bplc.vamosRodar()
