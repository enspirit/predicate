require 'spec_helper'
class Predicate
  describe Eq, "&" do

    let(:left){
      Factory.eq(:x, 2)
    }

    subject{ left & right }

    context 'with an eq leading to a contradiction' do
      let(:right){ Factory.eq(:x, 3) }

      it{
        expect(subject).to be_a(Contradiction)
      }
    end

    context 'with an IN on same variable and literal' do
      let(:right){ Factory.in(:x, [2,4]) }

      it{
        expect(subject).to be(left)
      }
    end

    context 'with an IN on same variable and opaque' do
      let(:right){ Factory.in(:x, Factory.opaque([3,4])) }

      it{
        expect(subject).to be_a(And)
      }
    end

    context 'with an IN having a placeholder' do
      let(:right){ Factory.in(:x, Factory.placeholder) }

      it{
        expect(subject).to be_a(And)
      }
    end

  end
end
