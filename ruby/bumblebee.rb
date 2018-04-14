require 'parslet'
require_relative 'smc'
require_relative 'bplc'

No = Struct.new(:dad ,:left, :right)

class Bumblebee < Parslet::Transform #transform que aplica operaçoes matematicas


  rule(:left => simple(:left), :right => simple(:right), :op => '+'){
    @smc = SMC.new
    @smc.empilhaControle('add')
    @smc.empilhaControle(Integer(left))
    @smc.empilhaControle(Integer(right))
    @bplc = BPLC.new(@smc)
    @bplc.roda()
  }

  rule(:left => simple(:left), :right => simple(:right), :op => '-'){

    @smc = SMC.new
    @smc.empilhaControle('-')
    @smc.empilhaControle(Integer(left))
    @smc.empilhaControle(Integer(right))
    roda(@smc)
  }

  rule(:left => simple(:left), :right => simple(:right), :op => '*'){
    @smc = SMC.new
    @smc.empilhaControle('*')
    @smc.empilhaControle(Integer(left))
    @smc.empilhaControle(Integer(right))
    roda(@smc)
  }

  rule(:left => simple(:left), :right => simple(:right), :op => '/'){
    @smc = SMC.new
    @smc.empilhaControle('/')
    @smc.empilhaControle(Integer(left))
    @smc.empilhaControle(Integer(right))
    roda(@smc)
  }

end

=begin
puts("--------------Parsing, Transform & Execucao--------------")
puts(Bumblebee.new.apply(parse("10+5")))
puts(Bumblebee.new.apply(parse("10-5")))
puts(Bumblebee.new.apply(parse("10*5")))
puts(Bumblebee.new.apply(parse("10/5")))
=end

