require 'parslet'
require_relative 'smc'
require_relative 'bplc'



class Bumblebee < Parslet::Transform #transform que aplica operaçoes matematicas


  rule(:int => simple(:n)) {
    IntLit.new(n)
  }

  rule(:string => simple(:c)) {
    StringLit.new(c)
  }

#So you don’t want to listen and really want that big gun with the foot aiming addon. You’ll be needing subtree(symbol).
  rule(:left => simple(:l), :right => simple(:r), :op => '+'){
    Addition.new(l, r)
=begin
    @smc = SMC.new
    @smc.empilhaControle('add')
    @smc.empilhaControle(l)
    @smc.empilhaControle(r)
    @bplc = BPLC.new(@smc)
=end
  }

  rule(:left => simple(:l), :right => simple(:r), :op => '-'){
    Subtractor.new(l, r)
  }

  rule(:left => simple(:l), :right => simple(:r), :op => '*'){
    Multiply.new(l,r)
  }

  rule(:left => simple(:l), :right => simple(:r), :op => '/'){
    Division.new(l,r)
  }

  rule(:ident => simple(:i), :val => subtree(:v), :ass_op=> ':= '){
    Assignment.new(i,v)
  }

end

=begin
puts("--------------Parsing, Transform & Execucao--------------")
puts(Bumblebee.new.apply(parse("10+5")))
puts(Bumblebee.new.apply(parse("10-5")))
puts(Bumblebee.new.apply(parse("10*5")))
puts(Bumblebee.new.apply(parse("10/5")))
=end

@@smc = SMC.new

Addition = Struct.new(:left, :right) do
  def eval
    @@smc.empilhaControle('add')

    unless(left.eval.nil?)
      @@smc.empilhaControle(left.eval)
    end

    unless(right.eval.nil?)
      @@smc.empilhaControle(right.eval)
    end
  end
end

Subtractor = Struct.new(:left, :right) do
  def eval
    @@smc.empilhaControle('sub')

    unless(left.eval.nil?)
      @@smc.empilhaControle(left.eval)
    end

    unless(right.eval.nil?)
      @@smc.empilhaControle(right.eval)
    end

  end
end

Multiply = Struct.new(:left, :right) do
  def eval
    $smc.empilhaControle('mul')

    unless(left.eval.nil?)
      $smc.empilhaControle(left.eval)

    end

    unless(right.eval.nil?)
      $smc.empilhaControle(right.eval)

    end

  end
end

Division = Struct.new(:left, :right) do
  def eval
    $smc.empilhaControle('div')

    unless(left.eval.nil?)
      $smc.empilhaControle(left.eval)
    end

    unless(right.eval.nil?)
      $smc.empilhaControle(right.eval)
    end
  end
end

Assignment = Struct.new(:ident, :val) do
  def eval
      $smc.empilhaControle(':=')
      $smc.empilhaControle(val.eval)
      $smc.empilhaControle(ident.eval)
  end
end

IntLit = Struct.new(:int) do
  def eval
    int.to_i
  end
end

StringLit = Struct.new(:string) do
  def eval
    string.to_s
  end
end