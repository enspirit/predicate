require_relative 'shared/a_predicate_ast_node'
class Predicate
  describe Factory, 'from_hash' do

    subject{ Factory.from_hash(h) }

    context "when the hash is empty" do
      let(:h){ {} }

      it {
        expect(subject).to eq(Factory.tautology)
      }
    end

    context "when the hash is a singelton" do
      let(:h){ {:x => 12} }

      it_should_behave_like "a predicate AST node"
      it {
        expect(subject).to be_a(Eq)
      }
      it {
        expect(subject).to eq([:eq, [:identifier, :x], [:literal, 12]])
      }
    end

    context "when the hash is not a singleton" do
      let(:h){ {:x => 12, :y => :z} }
      let(:expected){
        [:and,
          [:eq, [:identifier, :x], [:literal, 12]],
          [:eq, [:identifier, :y], [:identifier, :z]]]
      }

      it_should_behave_like "a predicate AST node"
      it {
        expect(subject).to be_a(And)
      }
      it {
        expect(subject).to eq(expected)
      }
    end

    context "when the hash has array values" do
      let(:h){ {:x => [12], :y => :z} }
      let(:expected){
        [:and,
          [:in, [:identifier, :x], [:literal, [12]]],
          [:eq, [:identifier, :y], [:identifier, :z]]]
      }

      it_should_behave_like "a predicate AST node"
      it {
        expect(subject).to be_a(And)
      }
      it {
        expect(subject).to eq(expected)
      }
    end

  end
end
