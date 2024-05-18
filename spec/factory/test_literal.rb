require_relative 'shared/a_predicate_ast_node'
class Predicate
  describe Factory, 'literal' do
    include Factory

    subject{ literal(12) }

    it_should_behave_like "a predicate AST node"
    it {
      expect(subject).to be_a(Literal)
    }
    it {
      expect(subject).to eql([:literal, 12])
    }

  end
end
