require 'spec_helper'
class Predicate
  describe And, "&" do

    let(:left){
      Factory.eq(:x, 2) & Factory.eq(:y, 3)
    }

    subject{ left & right }

    context 'with another predicate' do
      let(:right) {
        Factory.eq(:z, 4)
      }

      it 'collects it' do
        expect(subject).to be_a(And)
        expect(subject.size).to eql(4)
      end
    end

    context 'with another and' do
      let(:right) {
        Factory.eq(:w, 5) & Factory.eq(:z, 4)
      }

      it 'collects it' do
        expect(subject).to be_a(And)
        expect(subject.size).to eql(5)
      end
    end

  end
end