require 'spec_helper'
class Predicate
  describe Predicate, "&" do

    let(:left) { Predicate.coerce(x: 2) }

    subject{ left & right }

    before do
      subject.should be_a(Predicate)
    end

    context 'with itself' do
      let(:right){ left }

      it{ should be(left) }
    end

    context 'with the same expression' do
      let(:right){ Predicate.coerce(x: 2) }

      it{ should be(left) }
    end

    context 'with tautology' do
      let(:right){ Predicate.tautology }

      it 'returns self' do
        expect(subject).to eql(left)
      end
    end

    context 'with contradiction' do
      let(:right){ Predicate.contradiction }

      it 'returns contradiction' do
        expect(subject).to eql(right)
      end
    end

    context 'when using qualified names' do
      let(:right) { Predicate.coerce(x: 2) }

      it 'does not mix predicates' do
        l = left.qualify(:p1)
        r = right.qualify(:p2)
        expect(l & r).not_to eql(l)
      end

    end

  end
end
