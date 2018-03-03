require_relative 'shared/a_predicate_ast_node'
class Predicate
  describe Factory, 'from_hash' do

    subject{ Factory.from_hash(h) }

    context "when the hash is empty" do
      let(:h){ {} }

      it{ should eq(Factory.tautology) }
    end

    context "when the hash is a singelton" do
      let(:h){ {:x => 12} }

      it_should_behave_like "a predicate AST node"
      it{ should be_a(Eq) }
      it{ should eq([:eq, [:identifier, :x], [:literal, 12]]) }
    end

    context "when the hash is not a singleton" do
      let(:h){ {:x => 12, :y => :z} }
      let(:expected){
        [:and,
          [:eq, [:identifier, :x], [:literal, 12]],
          [:eq, [:identifier, :y], [:identifier, :z]]]
      }

      it_should_behave_like "a predicate AST node"
      it{ should be_a(And) }
      it{ should eq(expected) }
    end

    context "when the hash has array values" do
      let(:h){ {:x => [12], :y => :z} }
      let(:expected){
        [:and,
          [:in, [:identifier, :x], [12]],
          [:eq, [:identifier, :y], [:identifier, :z]]]
      }

      it_should_behave_like "a predicate AST node"
      it{ should be_a(And) }
      it{ should eq(expected) }
    end

  end
end
