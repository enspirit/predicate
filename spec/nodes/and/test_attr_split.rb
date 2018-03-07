require 'spec_helper'
class Predicate
  describe And, "attr_split" do

    let(:tautology){ Factory.tautology  }

    subject{ predicate.attr_split }

    context 'when each side returns a singleton hash' do
      let(:predicate){ Factory.eq(:x, 2) & Factory.eq(:y, 3) }

      it 'returns the hash union' do
        expect(subject).to eql({
          :x => Factory.eq(:x, 2),
          :y => Factory.eq(:y, 3)
        })
      end
    end

    context 'when right and left side share some attributes' do
      let(:predicate){
        Factory.eq(:x, 2) & (
          Factory.eq(:y, 3) & Factory.in(:x, [1, 18])
        )
      }

      it 'returns the hash union' do
        expect(subject).to eql({
          :x => Factory.eq(:x, 2) & Factory.in(:x, [1, 18]),
          :y => Factory.eq(:y, 3)
        })
      end
    end

    context 'when right and left side share some attributes, but split cannot be made' do
      let(:predicate){
        Factory.eq(:x, 2) & (
          Factory.eq(:y, 3) | Factory.in(:x, [1, 18])
        )
      }

      it 'returns the hash union' do
        expect(subject).to eql({
          :x  => Factory.eq(:x, 2),
          nil => Factory.eq(:y, 3) | Factory.in(:x, [1, 18])
        })
      end
    end
  end
end
