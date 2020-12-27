require 'spec_helper'
class Predicate
  describe Predicate, "constant_variables" do

    subject{ p.constant_variables }

    describe "on a comp(:eq)" do
      let(:p){ Predicate.coerce(x: 2, y: 3) }

      it{ expect(subject).to eql([:x, :y]) }
    end

    describe "on a comp(:eq) with placeholder" do
      let(:p){ Predicate.coerce(x: Predicate.placeholder) }

      it{ expect(subject).to eql([:x]) }
    end

    describe "on a in with one value" do
      let(:p){ Predicate.in(:x, [2]) }

      it{ expect(subject).to eql([:x]) }
    end

    describe "on a in with one placeholder" do
      let(:p){ Predicate.in(:x, Predicate.placeholder) }

      it{ expect(subject).to eql([]) }
    end

    describe "on an intersect with many values" do
      let(:p){ Predicate.intersect(:x, [2, 3]) }

      it{ expect(subject).to eql([]) }
    end

    describe "on an intersect with one value" do
      let(:p){ Predicate.intersect(:x, [2]) }

      it{ expect(subject).to eql([]) }
    end

    describe "on an intersect with a placeholder" do
      let(:p){ Predicate.intersect(:x, Predicate.placeholder) }

      it{ expect(subject).to eql([]) }
    end

    describe "on an subset with one value" do
      let(:p){ Predicate.subset(:x, [2]) }

      it{ expect(subject).to eql([]) }
    end

    describe "on an subset with a placeholder" do
      let(:p){ Predicate.subset(:x, Predicate.placeholder) }

      it{ expect(subject).to eql([]) }
    end

    describe "on an superset with one value" do
      let(:p){ Predicate.superset(:x, [2]) }

      it{ expect(subject).to eql([]) }
    end

    describe "on an superset with a placeholder" do
      let(:p){ Predicate.superset(:x, Predicate.placeholder) }

      it{ expect(subject).to eql([]) }
    end

    describe "on a in with mutiple values" do
      let(:p){ Predicate.in(:x, [2, 3]) }

      it{ expect(subject).to eql([]) }
    end

    describe "on a in with an opaque right term" do
      let(:p){ Predicate.in(:x, Predicate.opaque([2])) }

      it{ expect(subject).to eql([]) }
    end

    describe "on a NOT" do
      let(:p){ !Predicate.coerce(x: 2) }

      it{ expect(subject).to eql([]) }
    end

    describe "on a AND" do
      let(:p){ Predicate.coerce(x: 2) & Predicate.coerce(y: 3) }

      it{ expect(subject).to eql([:x, :y]) }
    end

    describe "on a OR" do
      let(:p){ Predicate.coerce(x: 2) | Predicate.coerce(y: 3) }

      it{ expect(subject).to eql([]) }
    end

    describe "on a negated OR" do
      let(:p){ !(Predicate.coerce(x: 2) | Predicate.coerce(y: 3)) }

      pending("NNF would make constant_variables smarter"){
        expect(subject).to eql([:x, :y])
      }
    end

  end
end
