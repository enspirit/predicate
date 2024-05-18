require_relative 'a_predicate_ast_node'
shared_examples_for "a comparison factory method" do
  include Predicate::Factory
  include Predicate::Sugar

  context 'with two operands' do
    subject{ self.send(method, true, true) }

    it_should_behave_like "a predicate AST node"
    it {
      expect(subject).to be_a(node_class)
    }
    it {
      expect(subject).to eql([method, tautology, tautology])
    }
  end

  context 'with a Hash operand (singleton)' do
    subject{ self.send(method, :x => :y) }
    let(:expected){
      [method, [:identifier, :x], [:identifier, :y]]
    }

    it_should_behave_like "a predicate AST node"
    it {
      expect(subject).to eql(expected)
    }
  end

  context 'with a Hash operand' do
    subject{ self.send(method, :x => :y, :v => 2) }
    let(:expected){
      [:and,
        [method, [:identifier, :x], [:identifier, :y]],
        [method, [:identifier, :v], [:literal, 2]]]
    }

    it_should_behave_like "a predicate AST node"
    it {
      expect(subject).to eql(expected)
    }
  end

end
