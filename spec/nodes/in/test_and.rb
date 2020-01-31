require 'spec_helper'
class Predicate
  describe In, "&" do

    let(:left){
      Factory.in(:x, [2, 4, 8])
    }

    subject{ left & right }

    context 'with an eq on same variable' do
      let(:right){ Factory.eq(:x, 2) }

      it{ should be(right) }
    end

    context 'with an eq on same variable yielding a contradiction' do
      let(:right){ Factory.eq(:x, 3) }

      it{ should eql(Factory.contradiction) }
    end

    context 'with an in on same variable' do
      let(:right){ Factory.in(:x, [2, 4, 5]) }

      it{ should eql(Factory.in(:x, [2, 4])) }
    end

    context 'with an in on same variable, leading to a singleton' do
      let(:right){ Factory.in(:x, [2]) }

      it{ should eql(Factory.eq(:x, 2)) }
    end

    context 'with an eq on same variable, leading to a singleton' do
      let(:right){ Factory.in(:x, [2, 5]) }

      it{ should eql(Factory.eq(:x, 2)) }
    end

    context 'with an in on same variable, leading to a empty set' do
      let(:right){ Factory.in(:x, [5]) }

      it{ should eql(Factory.contradiction) }
    end

  end
end
