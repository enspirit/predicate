require_relative 'shared/a_predicate_ast_node'
class Predicate
  describe Factory, 'and' do
    include Factory

    subject{ self.and(true, true) }

    it_should_behave_like "a predicate AST node"
    it {
      expect(subject).to be_a(And)
    }
    it {
      expect(subject).to eql([:and, tautology, tautology])
    }

  end
end
