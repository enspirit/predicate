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

    describe "gt" do
      let(:predicate) {
        Predicate.gt(:x, 2)
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
          }.to raise_error(Minitest::Assertion, /Expected 2 to be > 2/)
        end
      end
    end

    describe "gte" do
      let(:predicate) {
        Predicate.gte(:x, 2)
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
          { x: 1 }
        }
        it 'works and throws' do
          expect{
            subject
          }.to raise_error(Minitest::Assertion, /Expected 1 to be >= 2/)
        end
      end
    end

    describe "lt" do
      let(:predicate) {
        Predicate.lt(:x, 2)
      }

      subject{
        predicate.assert!(input)
      }

      context "when ok" do
        let(:input){
          { x: 1 }
        }
        it 'works and returns 1' do
          expect(subject).to eql(1)
        end
      end

      context "when ko" do
        let(:input){
          { x: 2 }
        }
        it 'works and throws' do
          expect{
            subject
          }.to raise_error(Minitest::Assertion, /Expected 2 to be < 2/)
        end
      end
    end

    describe "lte" do
      let(:predicate) {
        Predicate.lte(:x, 2)
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
          }.to raise_error(Minitest::Assertion, /Expected 3 to be <= 2/)
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

    describe "and" do
      let(:predicate) {
        Predicate.eq(:x, 2) & Predicate.eq(:y, 2)
      }

      subject{
        predicate.assert!(input)
      }

      context "when ok" do
        let(:input){
          { x: 2, y: 2 }
        }
        it 'works and returns true' do
          expect(subject).to eql(true)
        end
      end

      context "when ko" do
        let(:input){
          { x: 2, y: 3 }
        }
        it 'works and throws' do
          expect{
            subject
          }.to raise_error(Minitest::Assertion, /Expected: 3\n  Actual: 2/)
        end
      end
    end

    describe "empty" do
      let(:predicate) {
        Predicate.empty(:x)
      }

      subject{
        predicate.assert!(input)
      }

      context "when ok" do
        let(:input){
          { x: [] }
        }
        it 'works and returns true' do
          expect(subject).to eql([])
        end
      end

      context "when ko" do
        let(:input){
          { x: [2] }
        }
        it 'works and throws' do
          expect{
            subject
          }.to raise_error(Minitest::Assertion, /Expected \[2\] to be empty/)
        end
      end
    end

    describe "in" do
      let(:predicate) {
        Predicate.in(:x, [2, 3, 4])
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
          { x: 8 }
        }
        it 'works and throws' do
          expect{
            subject
          }.to raise_error(Minitest::Assertion, /Expected \[2, 3, 4\] to include 8/)
        end
      end
    end

  end
end

