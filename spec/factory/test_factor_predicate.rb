require 'spec_helper'
class Predicate
  describe Factory, "_factor_predicate" do

    subject{ Factory.send(:_factor_predicate, arg) }

    context "on Expr" do
      let(:arg){ Grammar.sexpr([:literal, 12]) }

      it {
        expect(subject).to be(arg)
      }
    end

    context "on true" do
      let(:arg){ true }

      it {
        expect(subject).to be_a(Tautology)
      }
    end

    context "on false" do
      let(:arg){ false }

      it {
        expect(subject).to be_a(Contradiction)
      }
    end

    context "on Symbol" do
      let(:arg){ :name }

      it {
        expect(subject).to be_a(Identifier)
      }
    end

    context "on Proc" do
      let(:arg){ lambda{} }

      it {
        expect(subject).to be_a(Native)
      }
    end

    context "on Array" do
      let(:arg){ [:identifier, :name] }

      it {
        expect(subject).to be_a(Identifier)
      }
    end

    context "on 12" do
      let(:arg){ 12 }

      it {
        expect(subject).to be_a(Literal)
      }
    end

  end
end
