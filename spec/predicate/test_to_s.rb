require 'spec_helper'
class Predicate
  describe Predicate, "to_s" do

    let(:p){ Predicate }

    subject{ predicate.to_s }

    context "tautology" do
      let(:predicate){ Predicate.tautology }

      it{ expect(subject).to eql("true") }
    end

    context "contradiction" do
      let(:predicate){ Predicate.contradiction }

      it{ expect(subject).to eql("false") }
    end

    context "var" do
      let(:predicate){ Predicate.var("x.y") }

      it{ expect(subject).to eql("dig(x.y)") }
    end

    context "var when used in another predicate" do
      let(:predicate){
        v = Predicate.var("x.y")
        Predicate.eq(v, 6)
      }

      it{ expect(subject).to eql("dig(x.y) == 6") }
    end

  end
end
