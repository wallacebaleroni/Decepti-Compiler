require 'parslet'
require_relative 'smc'
require_relative 'bplc'



class Bumblebee < Parslet::Transform #transform que aplica operaçoes matematicas


  rule(:int => simple(:n)) {
    IntLit.new(n)
  }

  rule(:id => simple(:c)) {
    IdLit.new(c)
  }


#So you don’t want to listen and really want that big gun with the foot aiming addon. You’ll be needing subtree(symbol).
  rule(:left => simple(:l), :right => simple(:r), :op => '+ '){
    Addition.new(l, r)
=begin
    @smc = SMC.new
    @smc.empilhaControle('add')
    @smc.empilhaControle(l)
    @smc.empilhaControle(r)
    @bplc = BPLC.new(@smc)
=end
  }

  rule(:left => simple(:l), :right => simple(:r), :op => '- '){
    Subtractor.new(l, r)
  }

  rule(:left => simple(:l), :right => simple(:r), :op => '* '){
    Multiply.new(l,r)
  }

  rule(:left => simple(:l), :right => simple(:r), :op => '/ '){
    Division.new(l,r)
  }

  rule(:ident => simple(:i), :val => subtree(:v), :ass_op=> ':= '){
    Assignment.new(i,v)
  }

  rule(:leftb => simple(:lb), :rightb => simple(:rb), :opb=> '== '){
    Equal.new(lb,rb,false)
  }

  rule(:leftb => simple(:lb), :rightb => simple(:rb), :opb=> '> '){
    GreaterThan.new(lb,rb,false)
  }

  rule(:leftb => simple(:lb), :rightb => simple(:rb), :opb=> '>= '){
    GreaterEqual.new(lb,rb,false)
  }

  rule(:leftb => simple(:lb), :rightb => simple(:rb), :opb=> '< '){
    LessThan.new(lb,rb,false)
  }

  rule(:leftb => simple(:lb), :rightb => simple(:rb), :opb=> '<= '){
    LessEqual.new(lb,rb,false)
  }

  rule(:neg => '~ ', :leftb => simple(:lb), :rightb => simple(:rb), :opb=> '== '){
    Equal.new(lb,rb,true)
  }

  rule(:neg => '~ ', :leftb => simple(:lb), :rightb => simple(:rb), :opb=> '> '){
    GreaterThan.new(lb,rb,true)
  }

  rule(:neg => '~ ', :leftb => simple(:lb), :rightb => simple(:rb), :opb=> '>= '){
    GreaterEqual.new(lb,rb,true)
  }

  rule(:neg => '~ ', :leftb => simple(:lb), :rightb => simple(:rb), :opb=> '< '){
    LessThan.new(lb,rb,true)
  }

  rule(:neg => '~ ', :leftb => simple(:lb), :rightb => simple(:rb), :opb=> '<= '){
    LessEqual.new(lb,rb,true)
  }

  rule(:while => "while ",:cond => subtree(:cd),:block => subtree(:bl)){
    While.new(cd,bl)
  }

  rule(:cmd => subtree(:cmd)){
    Command.new(cmd)
  }

end

#Estruturas
Addition = Struct.new(:left, :right) do
  def eval
    $smc.empilhaControle('add')

    unless(left.eval.nil?)
      $smc.empilhaControle(left.eval)
    end

    unless(right.eval.nil?)
      $smc.empilhaControle(right.eval)
    end
  end
end

Subtractor = Struct.new(:left, :right) do
  def eval
    $smc.empilhaControle('sub')

    unless(left.eval.nil?)
      $smc.empilhaControle(left.eval)
    end

    unless(right.eval.nil?)
      $smc.empilhaControle(right.eval)
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
      $smc.empilhaControle('assign')
      $smc.empilhaControle(val.eval)
      $smc.empilhaControle('ident')
      $smc.empilhaControle(ident.eval)
  end
end

Equal = Struct.new(:leftbool, :rightbool,:ehNeg) do
  def eval
    if(ehNeg)
      $smc.empilhaControle('neg')
    end
    $smc.empilhaControle('eq')
    $smc.empilhaControle(rightbool.eval)
    $smc.empilhaControle(leftbool.eval)
  end
end

GreaterThan = Struct.new(:leftbool, :rightbool,:ehNeg) do
  def eval
    if(ehNeg)
      $smc.empilhaControle('neg')
    end
    $smc.empilhaControle('gt')
    $smc.empilhaControle(rightbool.eval)
    $smc.empilhaControle(leftbool.eval)
  end
end

GreaterEqual = Struct.new(:leftbool, :rightbool, :ehNeg) do
  def eval
    if(ehNeg)
      $smc.empilhaControle('neg')
    end
    $smc.empilhaControle('ge')
    $smc.empilhaControle(rightbool.eval)
    $smc.empilhaControle(leftbool.eval)
  end
end

LessThan = Struct.new(:leftbool, :rightbool, :ehNeg) do
  def eval
    if(ehNeg)
      $smc.empilhaControle('neg')
    end
    $smc.empilhaControle('lt')
    $smc.empilhaControle(rightbool.eval)
    $smc.empilhaControle(leftbool.eval)
  end
end

LessEqual = Struct.new(:leftbool, :rightbool, :ehNeg) do
  def eval
    if(ehNeg)
      $smc.empilhaControle('neg')
    end
    $smc.empilhaControle('le')
    $smc.empilhaControle(rightbool.eval)
    $smc.empilhaControle(leftbool.eval)
  end
end

While = Struct.new(:cond,:block) do
  def eval
    $smc.empilhaControle('fimloop')
    $smc.empilhaControle(cond.eval)
    $smc.empilhaControle(block.eval)
    $smc.empilhaControle('loop')
    $smc.empilhaControle(cond.eval)
  end
end

Command = Struct.new(:cmd) do
  def eval
    $smc.empilhaControle(cmd.eval)
  end
end

IntLit = Struct.new(:int) do
  def eval
    int.to_i
  end
end

IdLit = Struct.new(:id) do
  def eval
    id.to_s
  end
end
