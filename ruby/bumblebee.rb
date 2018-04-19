require 'parslet'
require_relative 'smc'
require_relative 'bplc'



class Bumblebee < Parslet::Transform #transform que aplica operaçoes matematicas


  rule(:int => simple(:n)) {
    Integer(n)
  }

#So you don’t want to listen and really want that big gun with the foot aiming addon. You’ll be needing subtree(symbol).
  rule(:op => '+',:left => simple(:l), :right=>{:left => simple(:r)}){ #!!!!!!!!!!:right=>{:left => simple(:r)!!!!!!!!!!!
    puts(:r)
    @smc = SMC.new
    @smc.empilhaControle('add')
    @smc.empilhaControle(l)
    @smc.empilhaControle(r)
    @bplc = BPLC.new(@smc)
    @bplc.vamosRodar()
  }

  rule(:op => '-',:left => simple(:l), :right => simple(:r)){
    @smc = SMC.new
    @smc.empilhaControle('sub')
    @smc.empilhaControle(l)
    @smc.empilhaControle(r)
    @bplc = BPLC.new(@smc)
    @bplc.vamosRodar()
  }
  rule(:op => 'mul',:left => simple(:l), :right => simple(:r)){
    @smc = SMC.new
    @smc.empilhaControle('mul')
    @smc.empilhaControle(l)
    @smc.empilhaControle(r)
    @bplc = BPLC.new(@smc)
    @bplc.vamosRodar()
  }
  rule(:op => '/',:left => simple(:l), :right => simple(:r)){
    @smc = SMC.new
    @smc.empilhaControle('div')
    @smc.empilhaControle(l)
    @smc.empilhaControle(r)
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

