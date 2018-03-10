require 'spec_helper'
class Predicate
  describe Predicate, "constants" do

    let(:p){ Predicate }
    subject{ pred.constants }

    context "on tautology" do
      let(:pred){ p.tautology }

      it{ should eq({}) }
    end

    context "on contradiction" do
      let(:pred){ p.contradiction }

      it{ should eq({}) }
    end

    context "on eq(identifier,value)" do
      let(:pred){ p.eq(:x, 2) }

      it{ should eq({x: 2}) }
    end

    context "on eq(value,identifier)" do
      let(:pred){ p.eq(2, :x) }

      it{ should eq({x: 2}) }
    end

    context "on eq(identifier,identifier)" do
      let(:pred){ p.eq(:x, :y) }

      it{ should eq({}) }
    end

    context "on not" do
      let(:pred){ !p.eq(:x, 2) }

      it{ should eq({}) }
    end

    context "on neq" do
      let(:pred){ p.neq(:x, 2) }

      it{ should eq({}) }
    end

    context "on gt" do
      let(:pred){ p.gt(:x, 2) }

      it{ should eq({}) }
    end

    context "on in (singleton)" do
      let(:pred){ p.in(:x, [2]) }

      it{ should eq({x: 2}) }
    end

    context "on in (multiples)" do
      let(:pred){ p.in(:x, [2, 3]) }

      it{ should eq({}) }
    end

    context "on and (two eqs)" do
      let(:pred){ p.eq(:x, 2) & p.eq(:y, 4) }

      it{ should eq({x: 2, y: 4}) }
    end

    context "on and (one eq)" do
      let(:pred){ p.eq(:x, 2) & p.in(:y, [4,8]) }

      it{ should eq({x: 2}) }
    end

    context "on and (one eq, one in, same variable)" do
      let(:pred){ p.in(:x, [4,8]) & p.eq(:x, 2) }

      it{ should eq({x: 2}) }
    end

    context "on and (contradiction)" do
      let(:pred){ p.eq(:x, 2) & p.eq(:x, 4) }

      it{ should eq({}) }
    end

    context "on intersect" do
      let(:pred){ p.intersect(:x, [4,8]) }

      it{ should eq({}) }
    end

    context "on or (two eqs)" do
      let(:pred){ p.eq(:x, 2) | p.eq(:y, 4) }

      it{ should eq({}) }
    end

    context "on native" do
      let(:pred){ p.native(->(t){}) }

      it{ should eq({}) }
    end

  end
end
