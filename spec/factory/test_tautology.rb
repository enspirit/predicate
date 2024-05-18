require_relative 'shared/a_predicate_ast_node'
class Predicate
  describe Factory, 'tautology' do
    include Factory

    subject{ tautology }

    it_should_behave_like "a predicate AST node"
    it {
      expect(subject).to be_a(Tautology)
    }

  end
end
