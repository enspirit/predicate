require 'spec_helper'
class Predicate
  describe Or, "and_split" do

    let(:tautology){ Factory.tautology  }

    subject{ predicate.and_split(list) }

    context 'when attributes on one side' do
      let(:predicate){ Factory.eq(:x, 2) | Factory.eq(:y, 3) }

      context 'when fully covered' do
        let(:list){ [:x, :y] }

        it {
          expect(subject).to eq([predicate, tautology])
        }
      end

      context 'when fully disjoint' do
        let(:list){ [:z] }

        it {
          expect(subject).to eq([tautology, predicate])
        }
      end

    end
  end
end
