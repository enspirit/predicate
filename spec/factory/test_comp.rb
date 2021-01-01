require_relative 'shared/a_predicate_ast_node'
class Predicate
  describe Factory, 'comp' do

    subject{ Factory.comp(:eq, h) }

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

    context "when the hash is not singleton" do
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

    context "when the value is a Regexp" do
      let(:rx){ /[a-z]+/ }
      let(:h){ {:x => /[a-z]+/} }

      it_should_behave_like "a predicate AST node"
      it{ should be_a(Match) }
      it{ should eq([:match, [:identifier, :x], [:literal, rx]]) }
    end

    context "when the hash mixes value types" do
      let(:rx){ /[a-z]+/ }
      let(:h){ {:x => 12, :y => rx} }
      let(:expected){
        [:and,
          [:eq, [:identifier, :x], [:literal, 12]],
          [:match, [:identifier, :y], [:literal, rx]]]
      }

      it_should_behave_like "a predicate AST node"
      it{ should be_a(And) }
      it{ should eq(expected) }
    end

  end
end
