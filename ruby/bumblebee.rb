require 'parslet'
require_relative 'smc'
require_relative 'bplc'


class Bumblebee < Parslet::Transform

  rule(:int => simple(:n)) {
    IntLit.new(n)
  }

  rule(:id => simple(:c)) {
    IdLit.new(c)
  }

  rule(:left => simple(:l), :right => simple(:r), :op => '+') {
    Addition.new(l, r)
  }

  rule(:left => simple(:l), :right => simple(:r), :op => '-') {
    Subtractor.new(l,r)
  }

  rule(:left => simple(:l), :right => simple(:r), :op => '*') {
    Multiply.new(l,r)
  }

  rule(:left => simple(:l), :right => simple(:r), :op => '/') {
    Division.new(l,r)
  }

  rule(:ident => simple(:i), :val => subtree(:v), :ass_op=> ':=') {
    Assignment.new(i,v)
  }

  rule(:ident => simple(:i), :val => subtree(:v), :ass_op=> ':=', :cmd => subtree(:c)) {
    Assignment.new(i,v)
  }

  rule(:leftb => simple(:lb), :rightb => simple(:rb), :opb=> '==') {
    Equal.new(lb,rb,false)
  }

  rule(:leftb => simple(:lb), :rightb => simple(:rb), :opb=> '>') {
    GreaterThan.new(lb,rb,false)
  }

  rule(:leftb => simple(:lb), :rightb => simple(:rb), :opb=> '>=') {
    GreaterEqual.new(lb,rb,false)
  }

  rule(:leftb => simple(:lb), :rightb => simple(:rb), :opb=> '<') {
    LessThan.new(lb,rb,false)
  }

  rule(:leftb => simple(:lb), :rightb => simple(:rb), :opb=> '<=') {
    LessEqual.new(lb,rb,false)
  }

  rule(:neg => '~', :leftb => simple(:lb), :rightb => simple(:rb), :opb=> '==') {
    Equal.new(lb,rb,true)
  }

  rule(:neg => '~', :leftb => simple(:lb), :rightb => simple(:rb), :opb=> '>') {
    GreaterThan.new(lb,rb,true)
  }

  rule(:neg => '~', :leftb => simple(:lb), :rightb => simple(:rb), :opb=> '>=') {
    GreaterEqual.new(lb,rb,true)
  }

  rule(:neg => '~', :leftb => simple(:lb), :rightb => simple(:rb), :opb=> '<') {
    LessThan.new(lb,rb,true)
  }

  rule(:neg => '~', :leftb => simple(:lb), :rightb => simple(:rb), :opb=> '<=') {
    LessEqual.new(lb,rb,true)
  }

  rule(:while => "while", :cond => subtree(:cd), :block => subtree(:bl)) {
    While.new(cd,bl)
  }

  rule(:if => "if", :cond => subtree(:cd), :block => subtree(:bl)) {
    If.new(cd,bl)
  }

  rule(:if => "if", :cond => subtree(:cd), :block => subtree(:blif),:else => "else", :blockelse => subtree(:blelse)) {
    IfElse.new(cd,blif,blelse)
  }

  rule(:print => "print", :arg => subtree(:ag)) {
    Print.new(ag)
  }

  rule(:seq1 => subtree(:s1), :seq2 => subtree(:s2)) {
    Seq.new(s1, s2)
  }

  rule(:cmd => subtree(:cmd)) {
    Command.new(cmd)
  }

  rule(:proc => simple(:n), :parametros => subtree(:p), :block => subtree(:bl)) {
    Procedure.new(bl)
  }

end


#Estruturas
Addition = Struct.new(:left, :right) do
  def eval
    $smc.empilhaControle('add')

      $smc.empilhaControle(left)

      $smc.empilhaControle(right)
  end
end

Subtractor = Struct.new(:left, :right) do
  def eval
    $smc.empilhaControle('sub')

      $smc.empilhaControle(left)

      $smc.empilhaControle(right)

  end
end

Multiply = Struct.new(:left, :right) do
  def eval
    $smc.empilhaControle('mul')

      $smc.empilhaControle(left)

      $smc.empilhaControle(right)


  end
end

Division = Struct.new(:left, :right) do
  def eval
    $smc.empilhaControle('div')

      $smc.empilhaControle(left)

      $smc.empilhaControle(right)
  end
end

Assignment = Struct.new(:ident, :val) do
  def eval
      $smc.empilhaControle('assign')
      $smc.empilhaControle(val)
      $smc.empilhaControle(ident)
  end
end

Equal = Struct.new(:leftbool, :rightbool, :ehNeg) do
  def eval
    if(ehNeg)
      $smc.empilhaControle('neg')
    end
    $smc.empilhaControle('eq')
    $smc.empilhaControle(rightbool)
    $smc.empilhaControle(leftbool)
  end
end

GreaterThan = Struct.new(:leftbool, :rightbool,:ehNeg) do
  def eval
    if(ehNeg)
      $smc.empilhaControle('neg')
    end
    $smc.empilhaControle('gt')
    $smc.empilhaControle(rightbool)
    $smc.empilhaControle(leftbool)
  end
end

GreaterEqual = Struct.new(:leftbool, :rightbool, :ehNeg) do
  def eval
    if(ehNeg)
      $smc.empilhaControle('neg')
    end
    $smc.empilhaControle('ge')
    $smc.empilhaControle(rightbool)
    $smc.empilhaControle(leftbool)
  end
end

LessThan = Struct.new(:leftbool, :rightbool, :ehNeg) do
  def eval
    if(ehNeg)
      $smc.empilhaControle('neg')
    end
    $smc.empilhaControle('lt')
    $smc.empilhaControle(rightbool)
    $smc.empilhaControle(leftbool)
  end
end

LessEqual = Struct.new(:leftbool, :rightbool, :ehNeg) do
  def eval
    if(ehNeg)
      $smc.empilhaControle('neg')
    end
    $smc.empilhaControle('le')
    $smc.empilhaControle(rightbool)
    $smc.empilhaControle(leftbool)
  end
end

While = Struct.new(:cond,:block) do
  def eval
    $smc.empilhaControle(block.eval)
    $smc.empilhaControle('loop')
    $smc.empilhaControle(cond.eval)
  end
end

If = Struct.new(:cond,:block) do
  def eval
    $smc.empilhaControle(block)
    $smc.empilhaControle('if')
    $smc.empilhaControle(cond)
  end
end

IfElse = Struct.new(:cond,:blockif,:blockelse) do
  def eval
    $smc.empilhaControle(blockelse)
    $smc.empilhaControle('else')
    $smc.empilhaControle(blockif)
    $smc.empilhaControle('if')
    $smc.empilhaControle(cond)
  end
end

Print = Struct.new(:ag) do
  def eval
    $smc.empilhaControle('print')
    $smc.empilhaControle(ag)
  end
end

Seq = Struct.new(:s1, :s2) do
  def eval
    $smc.empilhaControle(s2)
    $smc.empilhaControle(';')
    $smc.empilhaControle(s1)
  end
end

Command = Struct.new(:cmd) do
  def eval
    $smc.empilhaControle(cmd)
  end
end

Procedure = Struct.new(:bl) do
  def eval
    $smc.empilhaControle(bl)
  end
end

IntLit = Struct.new(:int) do
  def eval
    $smc.empilhaControle(int.to_i)
  end
end

IdLit = Struct.new(:id) do
  def eval
    $smc.empilhaControle(id.to_s)
  end
end
