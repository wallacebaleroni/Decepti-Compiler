require 'parslet'
require_relative 'smc'
require_relative 'bplc'
require_relative 'tree'


class Bumblebee < Parslet::Transform
  #mark0
  rule(:int => simple(:n)) {
    Tree.new(n)
  }

  rule(:id => simple(:c)) {
    Tree.new(c)
  }

  rule(:left => simple(:l), :right => simple(:r), :op => '+') {
    Tree.new("add", [l, r])
  }

  rule(:left => simple(:l), :right => simple(:r), :op => '-') {
    Tree.new("sub", [l, r])
  }

  rule(:left => simple(:l), :right => simple(:r), :op => '*') {
    Tree.new("mul", [l, r])
  }

  rule(:left => simple(:l), :right => simple(:r), :op => '/') {
    Tree.new("div", [l, r])
  }

  rule(:ident => simple(:i), :val => subtree(:v), :ass_op=> ':=') {
    Tree.new("assign", [i, v])
  }

  rule(:ident => simple(:i), :val => subtree(:v), :ass_op=> ':=', :cmd => subtree(:c)) {
    Tree.new("assign", [i, v])
  }

  rule(:neg => '~', :bool => simple(:bl)) {
    Tree.new("neg", [bl])
  }

  rule(:bool => simple(:bl))

  rule(:leftb => simple(:lb), :rightb => simple(:rb), :opb=> '==') {
    Tree.new("eq", [lb, rb])
  }

  rule(:leftb => simple(:lb), :rightb => simple(:rb), :opb=> '>') {
    Tree.new("gt", [lb, rb])
  }

  rule(:leftb => simple(:lb), :rightb => simple(:rb), :opb=> '>=') {
    Tree.new("gteq", [lb, rb])
  }

  rule(:leftb => simple(:lb), :rightb => simple(:rb), :opb=> '<') {
    Tree.new("lt", [lb, rb])
  }

  rule(:leftb => simple(:lb), :rightb => simple(:rb), :opb=> '<=') {
    Tree.new("lteq", [lb, rb])
  }

  rule(:while => "while", :cond => simple(:cd), :block => subtree(:bl)) {
    Tree.new("while", [cd, bl])
  }

  rule(:if => "if", :cond => subtree(:cd), :block => subtree(:bl)) {
    Tree.new("if", [cd, bl, nil])
  }

  rule(:if => "if", :cond => subtree(:cd), :block => subtree(:block_if),:else => "else", :blockelse => subtree(:block_else)) {
    Tree.new("if", [cd, block_if, block_else])
  }

  rule(:print => "print", :arg => subtree(:ag)) {
    Tree.new("print", [ag])
  }

  rule(:seq1 => subtree(:s1), :seq2 => subtree(:s2)) {
    Tree.new("seq", [s1, s2])
  }

  rule(:cmd => subtree(:cmd)) {
    Tree.new("cmd", [cmd])
  }

  rule(:proc => simple(:n), :parametros => subtree(:p), :block => subtree(:bl)) {
    $smc.pushC(Tree.new("proc", [bl]))
  }

  #mark1
=begin
  rule(:ident => simple(:i), :val => subtree(:v), :var=> 'var') {
    $smc.pushC(Tree.new("var", [i, v]))
  }
=end

  rule(:decl_seq1 => subtree(:s1), :decl_seq2 => subtree(:s2)) {
    Tree.new("decl_seq", [s1, s2])
  }

  rule(:decl => subtree(:decl), :declp_op => "var", :ini_seq => subtree(:ini_seq)) { # ??
    Tree.new("decl", [decl_op, ini_seq])
  }

  rule(:ini_seq1 => subtree(:s1), :ini_seq2 => subtree(:s2)) {
    Tree.new("ini_seq", [s1, s2])
  }

  rule(:id => simple(:i), :value => subtree(:v), :ini_op=> '=') {
    Tree.new("ini", [i, v])
  }

end
