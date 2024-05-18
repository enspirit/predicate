require 'spec_helper'
class Predicate
  describe Predicate, "constants" do

    let(:p){ Predicate }
    subject{ pred.constants }

    context "on tautology" do
      let(:pred){ p.tautology }

      it {
        expect(subject).to eq({})
      }
    end

    context "on contradiction" do
      let(:pred){ p.contradiction }

      it {
        expect(subject).to eq({})
      }
    end

    context "on eq(identifier,value)" do
      let(:pred){ p.eq(:x, 2) }

      it {
        expect(subject).to eq({x: 2})
      }
    end

    context "on eq(identifier,placeholder)" do
      let(:pred){ p.eq(:x, p.placeholder) }

      it {
        expect(subject).to eq({})
      }
    end

    context "on eq(value,identifier)" do
      let(:pred){ p.eq(2, :x) }

      it {
        expect(subject).to eq({x: 2})
      }
    end

    context "on eq(identifier,identifier)" do
      let(:pred){ p.eq(:x, :y) }

      it {
        expect(subject).to eq({})
      }
    end

    context "on not" do
      let(:pred){ !p.eq(:x, 2) }

      it {
        expect(subject).to eq({})
      }
    end

    context "on neq" do
      let(:pred){ p.neq(:x, 2) }

      it {
        expect(subject).to eq({})
      }
    end

    context "on gt" do
      let(:pred){ p.gt(:x, 2) }

      it {
        expect(subject).to eq({})
      }
    end

    context "on in (singleton)" do
      let(:pred){ p.in(:x, [2]) }

      it {
        expect(subject).to eq({x: 2})
      }
    end

    context "on in (multiples)" do
      let(:pred){ p.in(:x, [2, 3]) }

      it {
        expect(subject).to eq({})
      }
    end

    context "on in (opaque)" do
      let(:pred){ p.in(:x, p.opaque([2])) }

      it {
        expect(subject).to eq({})
      }
    end

    context "on and (two eqs)" do
      let(:pred){ p.eq(:x, 2) & p.eq(:y, 4) }

      it {
        expect(subject).to eq({x: 2, y: 4})
      }
    end

    context "on and (one eq)" do
      let(:pred){ p.eq(:x, 2) & p.in(:y, [4,8]) }

      it {
        expect(subject).to eq({x: 2})
      }
    end

    context "on and (one eq, one in, same variable)" do
      let(:pred){ p.in(:x, [2,8]) & p.eq(:x, 2) }

      it {
        expect(subject).to eq({x: 2})
      }
    end

    context "on and (one eq, one in, yielding contradiction)" do
      let(:pred){ p.in(:x, [3,8]) & p.eq(:x, 2) }

      it {
        expect(subject).to eq({})
      }
    end

    context "on and (contradiction)" do
      let(:pred){ p.eq(:x, 2) & p.eq(:x, 4) }

      it {
        expect(subject).to eq({})
      }
    end

    context "on intersect" do
      let(:pred){ p.intersect(:x, [4,8]) }

      it {
        expect(subject).to eq({})
      }
    end

    context "on intersect with placeholder" do
      let(:pred){ p.intersect(:x, p.placeholder) }

      it {
        expect(subject).to eq({})
      }
    end

    context "on subset" do
      let(:pred){ p.subset(:x, [4,8]) }

      it {
        expect(subject).to eq({})
      }
    end

    context "on subset with placeholder" do
      let(:pred){ p.subset(:x, p.placeholder) }

      it {
        expect(subject).to eq({})
      }
    end

    context "on superset" do
      let(:pred){ p.superset(:x, [4,8]) }

      it {
        expect(subject).to eq({})
      }
    end

    context "on superset with placeholder" do
      let(:pred){ p.superset(:x, p.placeholder) }

      it {
        expect(subject).to eq({})
      }
    end

    context "on or (two eqs)" do
      let(:pred){ p.eq(:x, 2) | p.eq(:y, 4) }

      it {
        expect(subject).to eq({})
      }
    end

    context "on match" do
      let(:pred){ p.match(:x, "London") }

      it {
        expect(subject).to eq({})
      }
    end

    context "on native" do
      let(:pred){ p.native(->(t){}) }

      it {
        expect(subject).to eq({})
      }
    end

  end
end
