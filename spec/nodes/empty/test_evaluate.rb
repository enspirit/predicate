require 'spec_helper'
class Predicate
  describe Empty, "evaluate" do

    let(:predicate){ Factory.empty(:x) }

    subject{ predicate.evaluate(context) }

    context "on an empty array" do
      let(:context){ { x: [] } }

      it{ expect(subject).to eq(true) }
    end

    context "on a non empty array" do
      let(:context){ { x: [1, 2, 3] } }

      it{ expect(subject).to eq(false) }
    end

    context "on a empty string" do
      let(:context){ { x: "" } }

      it{ expect(subject).to eq(true) }
    end

    context "on a non empty string" do
      let(:context){ { x: "1233" } }

      it{ expect(subject).to eq(false) }
    end

    context "on an object that does not respond to empty?" do
      let(:context){ { x: 14567 } }

      it{
        expect{ subject }.to raise_error(TypeError, "Expected 14567 to respond to empty?")
      }
    end

  end
end
