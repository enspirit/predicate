require 'spec_helper'
class Predicate
  describe Predicate, "|" do

    let(:left) { Predicate.coerce(x: 2) }

    subject{ left | right }

    before do
      expect(subject).to be_a(Predicate)
    end

    context 'with itself' do
      let(:right){ left }

      it {
        expect(subject).to be(left)
      }
    end

    context 'with the same expression' do
      let(:right){ Predicate.coerce(x: 2) }

      it {
        expect(subject).to be(left)
      }
    end

  end
end
