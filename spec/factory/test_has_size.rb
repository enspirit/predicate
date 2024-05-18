require_relative 'shared/a_predicate_ast_node'
class Predicate
  describe Factory, 'has_size' do
    include Factory
    subject{ has_size(:x, 1..10) }

    it_should_behave_like "a predicate AST node"

    it {
      expect(subject).to be_a(HasSize)
    }
  end
end
