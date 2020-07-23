require 'spec_helper'
class Predicate
  describe Predicate, "to_hash" do

    let(:p){ Predicate }

    subject{ predicate.to_hash }

    context "tautology" do
      let(:predicate){ Predicate.tautology }

      it{ expect(subject).to eql({}) }
    end

    context "contradiction" do
      let(:predicate){ Predicate.contradiction }

      it{ expect{ subject }.to raise_error(ArgumentError) }
    end

    context "eq" do
      let(:predicate){ Predicate.eq(:x, 2) }

      it{ expect(subject).to eql(x: 2) }
    end

    context "in" do
      let(:predicate){ Predicate.in(:x, [2,3]) }

      it{ expect(subject).to eql(x: [2,3]) }
    end

    context "and" do
      let(:predicate){ Predicate.eq(:x, 3) & Predicate.in(:y, [2,3]) }

      it{ expect(subject).to eql(x: 3, y: [2,3]) }
    end

  end
end
