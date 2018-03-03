require 'spec_helper'
class Predicate
  describe Predicate, "hash and ==" do

    subject{ left == right }

    after do
      left.hash.should eq(right.hash) if subject
    end

    describe "on equal predicates" do
      let(:left) { Predicate.coerce(:x => 2) }
      let(:right){ Predicate.coerce(:x => 2) }

      it{ should be(true) }
    end

    describe "on non equal predicates" do
      let(:left) { Predicate.coerce(:x => 2) }
      let(:right){ Predicate.coerce(:x => 3) }

      it{ should be(false) }
    end

  end
end
