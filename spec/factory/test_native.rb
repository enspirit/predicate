require_relative 'shared/a_predicate_ast_node'
class Predicate
  describe Factory, 'native' do
    include Factory

    subject{ native(proc) }

    context 'with a proc' do
      let(:proc){ ->{} }

      it_should_behave_like "a predicate AST node"

      it {
        expect(subject).to be_a(Native)
      }

      it {
        expect(subject).to eql([:native, proc])
      }
    end

  end
end
