require 'spec_helper'
class Predicate
  describe Predicate, "unqualify" do

    let(:p){ Predicate }

    subject{ predicate.unqualify }

    context 'when the predicate is not qualified' do
      let(:predicate){ p.in(:x, [2]) & p.eq(:y, :z) }

      it 'works as expected' do
        expect(subject).to eql(predicate)
      end
    end

  end
end
