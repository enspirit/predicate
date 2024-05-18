require_relative 'shared/a_predicate_ast_node'
class Predicate
  describe Factory, 'or' do
    include Factory

    subject{ self.or(true, true) }

    it_should_behave_like "a predicate AST node"
    it {
      expect(subject).to be_a(Or)
    }
    it {
      expect(subject).to eql([:or, tautology, tautology])
    }

  end
end
