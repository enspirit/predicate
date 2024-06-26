require 'spec_helper'
class Predicate
  describe And, "and_split" do

    let(:tautology){ Factory.tautology  }

    subject{ predicate.and_split(list) }

    context 'when attributes on one side' do
      let(:predicate){ Factory.eq(:x, 2) & Factory.eq(:y, 3) }

      context 'when fully covered' do
        let(:list){ [:x, :y] }

        it {
          expect(subject).to eq([predicate, tautology])
        }
      end

      context 'when not covered at all' do
        let(:list){ [:name] }

        it {
          expect(subject).to eq([tautology, predicate])
        }
      end

      context 'when partially covered' do
        let(:list){ [:x] }

        it {
          expect(subject).to eq([Factory.eq(:x, 2), Factory.eq(:y, 3)])
        }
      end
    end

    context 'when attributes on both sides' do
      let(:predicate){ Factory.eq(:x, 2) & Factory.eq(:y, :z) }

      context 'when fully covered' do
        let(:list){ [:x, :y, :z] }

        it {
          expect(subject).to eq([predicate, tautology])
        }
      end

      context 'when not covered at all' do
        let(:list){ [:name] }

        it {
          expect(subject).to eq([tautology, predicate])
        }
      end

      context 'when partially covered but split-able' do
        let(:list){ [:x] }

        it {
          expect(subject).to eq([Factory.eq(:x, 2), Factory.eq(:y, :z)])
        }
      end

      context 'when partially covered but split-able (2)' do
        let(:list){ [:y] }

        it {
          expect(subject).to eq([Factory.eq(:y, :z), Factory.eq(:x, 2)])
        }
      end

      context 'when partially covered but not split-able' do
        let(:list){ [:x, :y] }

        it {
          expect(subject).to eq([predicate, tautology])
        }
      end
    end

    context 'with a native on one side' do
      let(:left) { Factory.eq(:x, 2)       }
      let(:right){ Factory.native(->(t){}) }
      let(:predicate){ left & right }

      context 'when fully covered' do
        let(:list){ [:x, :y, :z] }

        it {
          expect(subject).to eq([predicate, tautology])
        }
      end

      context 'when not covered' do
        let(:list){ [:y] }

        it {
          expect(subject).to eq([right, left])
        }
      end
    end

  end
end
