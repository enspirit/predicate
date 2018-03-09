require 'spec_helper'
class Predicate
  describe Predicate, "attr_split" do

    let(:p){ Predicate }
    subject{ pred.attr_split }

    context "on tautology" do
      let(:pred){ p.tautology }

      it{ should eq({}) }
    end

    context "on contradiction" do
      let(:pred){ p.contradiction }

      it{ should eq({ nil => pred }) }
    end

    context "on identifier" do
      let(:pred){ p.identifier(:x) }

      it{ should eq({ x: pred }) }
    end

    context "on not" do
      let(:pred){ p.not(:x) }

      it{ should eq({ x: pred }) }
    end

    context "on eq" do
      let(:pred){ p.eq(:x, 2) }

      it{ should eq({ x: pred }) }
    end

  end
end