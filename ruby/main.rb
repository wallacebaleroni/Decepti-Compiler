require_relative 'smc'
require_relative 'parceiroReborn'
require_relative 'bumblebee'

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
parceiro = ParceiroReborn.new()
parceiro.parsea('1+1')
parceiro.parsea('1+')

meh

TESTES bumblebee
autobot = Bumblebee.new()
puts(autobot.apply(parceiro.parsea("10+5")))
=end

Bumblebee.new.apply(ParceiroReborn.new.parsea("1+2"))
puts('\/\/\/\/\/\/\/\/')
Bumblebee.new.apply(ParceiroReborn.new.parsea("10-8"))
puts('\/\/\/\/\/\/\/\/')
Bumblebee.new.apply(ParceiroReborn.new.parsea("10*5"))
puts('\/\/\/\/\/\/\/\/')
Bumblebee.new.apply(ParceiroReborn.new.parsea("30/5"))
puts('\/\/\/\/\/\/\/\/')

