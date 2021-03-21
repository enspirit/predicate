require 'spec_helper'
class Predicate
  describe Predicate, "assert!" do

    describe "eq" do
      let(:predicate) {
        Predicate.eq(:x, 2)
      }

      subject{
        predicate.assert!(input)
      }

      context "when ok" do
        let(:input){
          { x: 2 }
        }
        it 'works and returns 2' do
          expect(subject).to eql(2)
        end
      end

      context "when ko" do
        let(:input){
          { x: 3 }
        }
        it 'works and throws' do
          expect{
            subject
          }.to raise_error(Minitest::Assertion, /Expected: 3\s+Actual: 2/)
        end
      end
    end

    describe "neq" do
      let(:predicate) {
        Predicate.neq(:x, 2)
      }

      subject{
        predicate.assert!(input)
      }

      context "when ok" do
        let(:input){
          { x: 3 }
        }
        it 'works and returns 3' do
          expect(subject).to eql(3)
        end
      end

      context "when ko" do
        let(:input){
          { x: 2 }
        }
        it 'works and throws' do
          expect{
            subject
          }.to raise_error(Minitest::Assertion, /Expected 2 to not be equal to 2./)
        end
      end
    end

  end
end

