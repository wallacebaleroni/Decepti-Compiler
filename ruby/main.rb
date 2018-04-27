require_relative 'optimusparser'
require_relative 'bumblebee'
require_relative 'bplc'
require_relative 'smc'

code = "proc fact(x) {
  x := 6;
  y := 1;
  while (~ x == 0) do {
      y := y * x;
      x := x - 1
  };
  print(y)
}"

$smc = SMC.new
bplc = BPLC.new
Bumblebee.new.apply(OptimusParser.new.rollOut(code))
bplc.vamosRodar($smc)