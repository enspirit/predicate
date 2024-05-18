require_relative 'shared/a_predicate_ast_node'
class Predicate
  describe Factory, 'var' do
    include Factory

    context 'when used with a string' do
      subject{ var("a.b.c", :dig) }

      it_should_behave_like "a predicate AST node"
      it {
        expect(subject).to be_a(Var)
      }
      it {
        expect(subject).to eql([:var, "a.b.c", :dig])
      }
    end

    context 'when used with an array' do
      subject{ var([:a, :b, :c], :dig) }

      it_should_behave_like "a predicate AST node"
      it {
        expect(subject).to be_a(Var)
      }
      it {
        expect(subject).to eql([:var, [:a, :b, :c], :dig])
      }
    end
  end
end
