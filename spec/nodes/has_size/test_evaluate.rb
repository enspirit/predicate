require 'spec_helper'
class Predicate
  describe HasSize, "evaluate" do

    let(:predicate){
      Factory.has_size(:x, y)
    }

    subject{ predicate.evaluate(context) }

    context 'against a Range' do
      let(:y){ 1..10 }

      context "on a match x" do
        let(:context){ { x: "1234567" } }

        it{ expect(subject).to eq(true) }
      end

      context "on a non matching x" do
        let(:context){ { x: "1234567891011" } }

        it{ expect(subject).to eq(false) }
      end
    end

    context 'against an Integer' do
      let(:y){ 10 }

      context "on a match x" do
        let(:context){ { x: "0123456789" } }

        it{ expect(subject).to eq(true) }
      end

      context "on a non matching x" do
        let(:context){ { x: "1234567891011" } }

        it{ expect(subject).to eq(false) }
      end
    end

  end
end
