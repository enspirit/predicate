require_relative 'shared/a_predicate_ast_node'
class Predicate
  describe Factory, 'identifier' do
    include Factory

    subject{ identifier(:name) }

    it_should_behave_like "a predicate AST node"
    it {
      expect(subject).to be_a(Identifier)
    }
    it {
      expect(subject).to eql([:identifier, :name])
    }

  end
end
