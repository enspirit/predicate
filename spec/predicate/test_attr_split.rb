require 'spec_helper'
class Predicate
  describe Predicate, "attr_split" do

    let(:p){ Predicate }
    subject{ pred.attr_split }

    context "on tautology" do
      let(:pred){ p.tautology }

      it {
        expect(subject).to eq({})
      }
    end

    context "on contradiction" do
      let(:pred){ p.contradiction }

      it {
        expect(subject).to eq({ nil => pred })
      }
    end

    context "on identifier" do
      let(:pred){ p.identifier(:x) }

      it {
        expect(subject).to eq({ x: pred })
      }
    end

    context "on not" do
      let(:pred){ p.not(:x) }

      it {
        expect(subject).to eq({ x: pred })
      }
    end

    context "on eq" do
      let(:pred){ p.eq(:x, 2) }

      it {
        expect(subject).to eq({ x: pred })
      }
    end

    context "on eq with placeholder" do
      let(:pred){ p.eq(:x, p.placeholder) }

      it {
        expect(subject).to eq({ x: pred })
      }
    end

    context "on in" do
      let(:pred){ p.in(:x, [2]) }

      it {
        expect(subject).to eq({ x: pred })
      }
    end

    context "on intersect" do
      let(:pred){ p.intersect(:x, [2]) }

      it {
        expect(subject).to eq({ x: pred })
      }
    end

    context "on subset" do
      let(:pred){ p.subset(:x, [2]) }

      it {
        expect(subject).to eq({ x: pred })
      }
    end

    context "on superset" do
      let(:pred){ p.superset(:x, [2]) }

      it {
        expect(subject).to eq({ x: pred })
      }
    end

    context "on match" do
      let(:pred){ p.match(:x, "London") }

      it {
        expect(subject).to eq({ x: pred })
      }
    end

    context "on match with two identifiers" do
      let(:pred){ p.match(:x, :y) }

      it {
        expect(subject).to eq({ nil => pred })
      }
    end

  end
end
