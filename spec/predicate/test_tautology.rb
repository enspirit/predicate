require 'spec_helper'
class Predicate
  describe Predicate, "tautology?" do

    context "tautology" do
      subject{ Predicate.tautology }

      it{ expect(subject.tautology?).to be(true) }
    end

    context "contradiction" do
      subject{ Predicate.contradiction }

      it{ expect(subject.tautology?).to be(false) }
    end

    context "identifier" do
      subject{ Predicate.identifier(:x) }

      it{ expect(subject.tautology?).to be(false) }
    end

  end
end
