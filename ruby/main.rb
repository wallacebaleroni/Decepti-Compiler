require_relative 'optimusparser'
require_relative 'bumblebee'
require_relative 'bplc'
require_relative 'smc'

=begin
$smc = SMC.new
bplc = BPLC.new

$smc.escreveAmbiente('x') #var x
$smc.escreveAmbiente('y') #var y

Bumblebee.new.apply(OptimusParser.new.rollOut("
proc fact(x) {
  x := 5;
  y := 1;
  while (x > 0) do {
      y := y * x;
      x := x - 1
  };
  print(y)
}"))
bplc.vamosRodar($smc)
=end

=begin
$smc = SMC.new
bplc = BPLC.new
Bumblebee.new.apply(OptimusParser.new.rollOut("
proc fact(x) {
  x := 6;
  y := 1;
  print(x * 2 + 1)
}
"))
bplc.vamosRodar($smc)
=end

=begin
$smc = SMC.new
bplc = BPLC.new
Bumblebee.new.apply(OptimusParser.new.rollOut("var x = 2"))
Bumblebee.new.apply(OptimusParser.new.rollOut("var y = 6"))
bplc.vamosRodar($smc)
=end

=begin
$smc = SMC.new
bplc = BPLC.new

Bumblebee.new.apply(OptimusParser.new.rollOut("var x = 1, y = 2, z = 3; var i = 4"))
bplc.vamosRodar()
=end

$smc = SMC.new
bplc = BPLC.new

Bumblebee.new.apply(OptimusParser.new.rollOut("
proc fact(x) {
  var x = 5;
  var y = 1;
  if (x > 0) {
      var z = 15;
      y := y * x;
      x := x - 1
  };
  print(y)
}"))
bplc.vamosRodar()