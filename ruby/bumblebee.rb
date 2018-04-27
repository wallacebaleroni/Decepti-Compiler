require 'parslet'
require_relative 'smc'
require_relative 'bplc'
require_relative 'tree'


class Bumblebee < Parslet::Transform

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

  rule(:leftb => simple(:lb), :rightb => simple(:rb), :opb=> '==') {
    Tree.new("eq", [lb, rb])
  }

  rule(:leftb => simple(:lb), :rightb => simple(:rb), :opb=> '>') {
    Tree.new("gt", [lb, rb])
  }

  rule(:leftb => simple(:lb), :rightb => simple(:rb), :opb=> '>=') {
    Tree.new("gteq" [lb, rb])
  }

  rule(:leftb => simple(:lb), :rightb => simple(:rb), :opb=> '<') {
    Tree.new("lt", [lb, rb])
  }

  rule(:leftb => simple(:lb), :rightb => simple(:rb), :opb=> '<=') {
    Tree.new("lteq", [lb, rb])
  }

  rule(:neg => '~', :leftb => simple(:lb), :rightb => simple(:rb), :opb=> '==') {
    Tree.new("neq", [lb, rb])
  }

  rule(:neg => '~', :leftb => simple(:lb), :rightb => simple(:rb), :opb=> '>') {
    Tree.new("ngt", [lb, rb])
  }

  rule(:neg => '~', :leftb => simple(:lb), :rightb => simple(:rb), :opb=> '>=') {
    Tree.new("ngteq", [lb, rb])
  }

  rule(:neg => '~', :leftb => simple(:lb), :rightb => simple(:rb), :opb=> '<') {
    Tree.new("nlt", [lb, rb])
  }

  rule(:neg => '~', :leftb => simple(:lb), :rightb => simple(:rb), :opb=> '<=') {
    Tree.new("nlteq", [lb, rb])
  }

  rule(:while => "while", :cond => subtree(:cd), :block => subtree(:bl)) {
    Tree.new("while", [cd, bl])
  }

  rule(:if => "if", :cond => subtree(:cd), :block => subtree(:bl)) {
    Tree.new("if", [cd, bl])
  }

  rule(:if => "if", :cond => subtree(:cd), :block => subtree(:blif),:else => "else", :blockelse => subtree(:blelse)) {
    Tree.new("if" [cd, blif, blelse])
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
    puts(Tree.new("proc", [bl]))
  }
end
