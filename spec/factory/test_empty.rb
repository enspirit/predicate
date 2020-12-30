require_relative 'shared/a_predicate_ast_node'
class Predicate
  describe Factory, 'empty' do
    include Factory
    subject{ empty(:x) }

    it_should_behave_like "a predicate AST node"

    it{ should be_a(Empty) }
  end
end
