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

      it 'is as expected' do
        expect(subject.to_ruby_code).to eql("->(t){ (t[:x] == 2) && (t[:y] == 3) && (t[:z] == 4) }")
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

      it 'is as expected' do
        expect(subject.to_ruby_code).to eql("->(t){ (t[:x] == 2) && (t[:y] == 3) && (t[:w] == 5) && (t[:z] == 4) }")
      end
    end

  end
end