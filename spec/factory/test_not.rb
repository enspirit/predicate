require_relative 'shared/a_predicate_ast_node'
class Predicate
  describe Factory, 'not' do
    include Factory

    subject{ self.not(true) }

    it_should_behave_like "a predicate AST node"
    it {
      expect(subject).to be_a(Not)
    }
    it {
      expect(subject).to eql([:not, tautology])
    }

  end
end
