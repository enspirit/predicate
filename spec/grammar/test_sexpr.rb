require 'spec_helper'
class Predicate
  describe Grammar, "sexpr" do

    subject{ Grammar.sexpr(expr) }

    let(:contradiction){
      [:contradiction, false]
    }

    let(:identifier){
      [:identifier, :name]
    }

    let(:values){
      [12, 15]
    }

    before do
      expect(subject).to be_a(Sexpr)
    end

    describe "tautology" do
      let(:expr){ [:tautology, true] }

      it {
        expect(subject).to be_a(Tautology)
      }
    end

    describe "contradiction" do
      let(:expr){ [:contradiction, false] }

      it {
        expect(subject).to be_a(Contradiction)
      }
    end

    describe "identifier" do
      let(:expr){ [:identifier, :name] }

      it {
        expect(subject).to be_a(Identifier)
      }
    end

    describe "and" do
      let(:expr){ [:and, contradiction, contradiction] }

      it {
        expect(subject).to be_a(And)
      }
    end

    describe "or" do
      let(:expr){ [:or, contradiction, contradiction] }

      it {
        expect(subject).to be_a(Or)
      }
    end

    describe "not" do
      let(:expr){ [:not, contradiction] }

      it {
        expect(subject).to be_a(Not)
      }
    end

    describe "eq" do
      let(:expr){ [:eq, identifier, identifier] }

      it {
        expect(subject).to be_a(Eq)
      }
    end

    describe "neq" do
      let(:expr){ [:neq, identifier, identifier] }

      it {
        expect(subject).to be_a(Neq)
      }
    end

    describe "gt" do
      let(:expr){ [:gt, identifier, identifier] }

      it {
        expect(subject).to be_a(Gt)
      }
    end

    describe "gte" do
      let(:expr){ [:gte, identifier, identifier] }

      it {
        expect(subject).to be_a(Gte)
      }
    end

    describe "lt" do
      let(:expr){ [:lt, identifier, identifier] }

      it {
        expect(subject).to be_a(Lt)
      }
    end

    describe "lte" do
      let(:expr){ [:lte, identifier, identifier] }

      it {
        expect(subject).to be_a(Lte)
      }
    end

    describe "in" do
      let(:expr){ [:in, identifier, values] }

      it {
        expect(subject).to be_a(In)
      }
    end

    describe "intersect" do
      let(:expr){ [:intersect, identifier, values] }

      it {
        expect(subject).to be_a(Intersect)
      }
    end

    describe "literal" do
      let(:expr){ [:literal, 12] }

      it {
        expect(subject).to be_a(Literal)
      }
    end

    describe "native" do
      let(:expr){ [:native, lambda{}] }

      it {
        expect(subject).to be_a(Native)
      }
    end

  end
end
