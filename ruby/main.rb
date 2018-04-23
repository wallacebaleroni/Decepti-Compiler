require_relative 'optimusparser'
require_relative 'bumblebee'
require_relative 'bplc'
require_relative 'smc'

=begin
P1 - 25 e 27/04 - Expressões e comandos.
    Objetivos:
    1-Ambientar-se com a linguagem escolhida e suas ferramentas.
    2-Entender PEG.
    3-Entender SMC.
    4-Implementar BPLC-mark0: (i) O tipo de dados SMC, (ii) operações aritméticas, Booleanas e comandos.
    5-Implementar um parser PEG para operações aritméticas, Booleanas e comandos.
    6-Implementar um compilador de AST PEG para operações aritméticas, Booleanas e comandos para BPLC-mark0.
=end

=begin
TESTES SMC
smc = SMC.new()
smc.empilhaValor(1)
smc.empilhaValor(2)
puts('---------')
smc.empilhaMemoria(1)
smc.empilhaMemoria(2)
puts('---------')
smc.empilhaControle(1)
smc.empilhaControle(2)

TESTES parceiroReborn
parceiro = OptimusParser.new()
parceiro.parsea('1+1')
parceiro.parsea('1+')

meh

TESTES bumblebee
autobot = Bumblebee.new()
puts(autobot.apply(parceiro.parsea("10+5")))
=end

=begin
Bumblebee.new.apply(OptimusParser.new.rollOut("1+2"))

Bumblebee.new.apply(OptimusParser.new.rollOut("10-8"))

Bumblebee.new.apply(OptimusParser.new.rollOut("10*5"))

Bumblebee.new.apply(OptimusParser.new.rollOut("30/5"))
=end


=begin
$smc = SMC.new
bplc = BPLC.new
Bumblebee.new.apply(OptimusParser.new.rollOut("1*2*3*4*5")).eval
bplc.vamosRodar($smc)
=end

=begin
$smc = SMC.new
bplc = BPLC.new
Bumblebee.new.apply(OptimusParser.new.rollOut("x := 1*2*3*4*5")).eval
bplc.vamosRodar($smc)
=end

=begin
$smc = SMC.new
bplc = BPLC.new
Bumblebee.new.apply(OptimusParser.new.rollOut("120 == 1*2*3*4*5")).eval
bplc.vamosRodar($smc)
=end

=begin
$smc = SMC.new
bplc = BPLC.new
Bumblebee.new.apply(OptimusParser.new.rollOut("~ x < 1*2*3*4*5")).eval
bplc.vamosRodar($smc)
=end

=begin
$smc = SMC.new
bplc = BPLC.new
Bumblebee.new.apply(OptimusParser.new.rollOut("while (~ y == 10) {
                      y := y + 1
                    }")).eval
bplc.vamosRodar($smc)
=end
