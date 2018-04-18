require 'parslet'
require_relative 'smc'
require_relative 'bplc'



class Bumblebee < Parslet::Transform #transform que aplica operaçoes matematicas


  rule(:left => simple(:left), :right => simple(:right), :op => '+'){
    @smc = SMC.new
    @smc.empilhaControle('add')
    @smc.empilhaControle(Integer(left))
    @smc.empilhaControle(Integer(right))
    @bplc = BPLC.new(@smc)
    @bplc.vamosRodar()
  }

  rule(:left => simple(:left), :right => simple(:right), :op => '-'){
    @smc = SMC.new
    @smc.empilhaControle('sub')
    @smc.empilhaControle(Integer(left))
    @smc.empilhaControle(Integer(right))
    @bplc = BPLC.new(@smc)
    @bplc.vamosRodar()
  }

  rule(:left => simple(:left), :right => simple(:right), :op => '*'){
    @smc = SMC.new
    @smc.empilhaControle('mul')
    @smc.empilhaControle(Integer(left))
    @smc.empilhaControle(Integer(right))
    @bplc = BPLC.new(@smc)
    @bplc.vamosRodar()
  }

  rule(:left => simple(:left), :right => simple(:right), :op => '/'){
    @smc = SMC.new
    @smc.empilhaControle('div')
    @smc.empilhaControle(Integer(left))
    @smc.empilhaControle(Integer(right))
    @bplc = BPLC.new(@smc)
    @bplc.vamosRodar()
  }

end

=begin
puts("--------------Parsing, Transform & Execucao--------------")
puts(Bumblebee.new.apply(parse("10+5")))
puts(Bumblebee.new.apply(parse("10-5")))
puts(Bumblebee.new.apply(parse("10*5")))
puts(Bumblebee.new.apply(parse("10/5")))
=end

