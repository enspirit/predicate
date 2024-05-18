require_relative 'shared/a_predicate_ast_node'
class Predicate
  describe Factory, 'qualified_identifier' do
    include Factory

    subject{ qualified_identifier(:t, :name) }

    it_should_behave_like "a predicate AST node"

    it{
      expect(subject).to be_a(QualifiedIdentifier)
    }

    it{
      expect(subject).to eql([:qualified_identifier, :t, :name])
    }

  end
end
