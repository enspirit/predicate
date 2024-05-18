require_relative 'shared/a_predicate_ast_node'
class Predicate
  describe Factory, 'match' do
    include Factory
    include Sugar

    context 'without options' do
      subject{ match(:name, "London") }

      it_should_behave_like "a predicate AST node"

      it {
        expect(subject).to be_a(Match)
      }

      it {
        expect(subject).to eql([:match, [:identifier, :name], [:literal, "London"]])
      }
    end

    context 'with options' do
      subject{ match(:name, "London", case_sensitive: false) }

      it_should_behave_like "a predicate AST node"

      it {
        expect(subject).to be_a(Match)
      }

      it {
        expect(subject).to eql([:match, [:identifier, :name], [:literal, "London"], {case_sensitive: false}])
      }
    end

  end
end
