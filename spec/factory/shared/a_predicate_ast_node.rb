require 'spec_helper'
shared_examples_for "a predicate AST node" do

  it {
    expect(subject).to be_a(Sexpr)
  }

  it {
    expect(subject).to be_a(Predicate::Expr)
  }

  specify{
    got = (subject.tautology? == subject.is_a?(Predicate::Tautology))
    expect(got).to be(true)
  }

  specify{
    got = (subject.contradiction? == subject.is_a?(Predicate::Contradiction))
    expect(got).to be(true)
  }

  specify{
    expect(subject.free_variables).to be_a(Array) unless subject.is_a?(Predicate::Native)
  }

end
