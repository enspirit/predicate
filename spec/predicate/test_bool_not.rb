require 'spec_helper'
class Predicate
  describe Predicate, "!" do

    subject{ !pred }

    context "on tautology" do
      let(:pred){ Predicate.tautology }

      it {
        expect(subject).to eq(Predicate.contradiction)
      }
    end

    context "on contradiction" do
      let(:pred){ Predicate.contradiction }

      it {
        expect(subject).to eq(Predicate.tautology)
      }
    end

    context "on not" do
      let(:pred){ Predicate.not(:x) }

      it {
        expect(subject).to eq(Predicate.identifier(:x))
      }
    end

    context "on comp" do
      let(:pred){ Predicate.comp(:eq, :x => 2) }

      it {
        expect(subject).to eq(Predicate.comp(:neq, :x => 2))
      }
    end

    context "on eq" do
      let(:pred){ Predicate.eq(:x => 2) }

      it {
        expect(subject).to eq(Predicate.neq(:x => 2))
      }
    end

    context "on neq" do
      let(:pred){ Predicate.neq(:x => 2) }

      it {
        expect(subject).to eq(Predicate.eq(:x => 2))
      }
    end

    context "on lt" do
      let(:pred){ Predicate.lt(:x => 2) }

      it {
        expect(subject).to eq(Predicate.gte(:x => 2))
      }
    end

    context "on lte" do
      let(:pred){ Predicate.lte(:x => 2) }

      it {
        expect(subject).to eq(Predicate.gt(:x => 2))
      }
    end

    context "on gt" do
      let(:pred){ Predicate.gt(:x => 2) }

      it {
        expect(subject).to eq(Predicate.lte(:x => 2))
      }
    end

    context "on gte" do
      let(:pred){ Predicate.gte(:x => 2) }

      it {
        expect(subject).to eq(Predicate.lt(:x => 2))
      }
    end

  end
end
