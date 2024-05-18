require 'spec_helper'
class Predicate
  describe DyadicComp, "and_split" do

    let(:predicate){ Factory.eq(:id, 2) }
    let(:tautology){ Factory.tautology  }

    subject{ predicate.and_split(list) }

    context 'when included' do
      let(:list){ [:id, :name] }

      it {
        expect(subject).to eq([predicate, tautology])
      }
    end

    context 'when not include' do
      let(:list){ [:name] }

      it {
        expect(subject).to eq([tautology, predicate])
      }
    end

    context 'with attributes on both sides' do
      let(:predicate){ Factory.eq(:x, :y) }

      context 'when full at left' do
        let(:list){ [:x, :y] }

        it {
          expect(subject).to eq([predicate, tautology])
        }
      end

      context 'none at left' do
        let(:list){ [] }

        it {
          expect(subject).to eq([tautology, predicate])
        }
      end

      context 'mix' do
        let(:list){ [:y] }

        it {
          expect(subject).to eq([predicate, tautology])
        }
      end
    end

  end
end
