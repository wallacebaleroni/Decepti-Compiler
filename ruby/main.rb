require_relative 'optimusparser'
require_relative 'bumblebee'
require_relative 'bplc'
require_relative 'smc'


$smc = SMC.new
bplc = BPLC.new

code = "proc fact(x) {
  var x = 5;
  var y = 1;
  const w = 40;
  while (x > 0) do {
      var z = 15;
      y := y * x;
      x := x - 1
  };
  print(w)
  }"

puts code
puts

$smc = SMC.new
bplc = BPLC.new
Bumblebee.new.apply(OptimusParser.new.rollOut(code))
bplc.vamosRodar()