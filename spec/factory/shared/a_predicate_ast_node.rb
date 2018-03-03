require 'spec_helper'
shared_examples_for "a predicate AST node" do

  it{ should be_a(Sexpr) }

  it{ should be_a(Predicate::Expr) }

  specify{
    (subject.tautology? == subject.is_a?(Predicate::Tautology)).should be(true)
  }

  specify{
    (subject.contradiction? == subject.is_a?(Predicate::Contradiction)).should be(true)
  }

  specify{
    subject.free_variables.should be_a(Array) unless subject.is_a?(Predicate::Native)
  }

end
