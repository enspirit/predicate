require 'spec_helper'
class Predicate
  describe Predicate, "contradiction?" do

    context "tautology" do
      subject{ Predicate.tautology }

      it{ expect(subject.contradiction?).to be(false) }
    end

    context "contradiction" do
      subject{ Predicate.contradiction }

      it{ expect(subject.contradiction?).to be(true) }
    end

    context "identifier" do
      subject{ Predicate.identifier(:x) }

      it{ expect(subject.contradiction?).to be(false) }
    end

  end
end
