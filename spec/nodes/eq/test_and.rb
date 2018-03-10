require 'spec_helper'
class Predicate
  describe Eq, "&" do

    let(:left){
      Factory.eq(:x, 2)
    }

    subject{ left & right }

    context 'with an eq leading to a contradiction' do
      let(:right){ Factory.eq(:x, 3) }

      it{ should be_a(Contradiction) }
    end

  end
end