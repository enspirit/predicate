require 'spec_helper'
class Predicate
  describe Predicate, "evaluate" do

    context 'on a native predicate of arity 1, used through tuple#[]' do
      let(:predicate){
        Predicate.native(->(t){ t[:name] =~ /foo/ })
      }

      context 'on a matching tuple' do
        let(:scope){ { :name => "foo" } }

        it{ expect(predicate.evaluate(scope)).to be_truthy }
      end

      context 'on a non-matching tuple' do
        let(:scope){ { :name => "bar" } }

        it{ expect(predicate.evaluate(scope)).to be_falsy }
      end
    end

    context 'on a native predicate of arity 1, used through tuple[:xxx]' do
      let(:predicate){
        Predicate.native(->(t){ t[:name] =~ /foo/ })
      }

      context 'on a matching tuple' do
        let(:scope){ { :name => "foo" } }

        it{ expect(predicate.evaluate(scope)).to be_truthy }
      end

      context 'on a non-matching tuple' do
        let(:scope){ { :name => "bar" } }

        it{ expect(predicate.evaluate(scope)).to be_falsy }
      end
    end

    context 'on a factored predicate' do
      let(:predicate){
        Predicate.new(Factory.lte(:x => 2))
      }

      describe "on x == 2" do
        let(:scope){ { :x => 2 } }

        it{ expect(predicate.evaluate(scope)).to be_truthy }
      end

      describe "on x == 1" do
        let(:scope){ { :x => 1 } }

        it{ expect(predicate.evaluate(scope)).to be_truthy }
      end

      describe "on x == 3" do
        let(:scope){ { :x => 3 } }

        it{ expect(predicate.evaluate(scope)).to be_falsy }
      end
    end

    context 'on an in predicate' do
      let(:predicate){
        Predicate.in(:x, [8,9])
      }

      describe "on x == 2" do
        let(:scope){ { :x => [2] } }

        it{ expect(predicate.evaluate(scope)).to be_falsy }
      end

      describe "on x == 8" do
        let(:scope){ { :x => 8 } }

        it{ expect(predicate.evaluate(scope)).to be_truthy }
      end
    end

    context 'on an intersect predicate, with array literal' do
      let(:predicate){
        Predicate.intersect(:x, [8,9])
      }

      describe "on x == [2]" do
        let(:scope){ { :x => [2] } }

        it{ expect(predicate.evaluate(scope)).to be_falsy }
      end

      describe "on x == [9,12]" do
        let(:scope){ { :x => [9,12] } }

        it{ expect(predicate.evaluate(scope)).to be_truthy }
      end
    end

    context 'on an intersect predicate, with two variables' do
      let(:predicate){
        Predicate.intersect(:x, :y)
      }

      describe "on x == [2]" do
        let(:scope){ { :x => [2], :y => [8,9] } }

        it{ expect(predicate.evaluate(scope)).to be_falsy }
      end

      describe "on x == [9,12]" do
        let(:scope){ { :x => [9,12], :y => [8,9] } }

        it{ expect(predicate.evaluate(scope)).to be_truthy }
      end
    end

    context 'on an subset predicate, with an array literal' do
      let(:predicate){
        Predicate.subset(:x, [8,9])
      }

      describe "on x == [2]" do
        let(:scope){ { :x => [2] } }

        it{ expect(predicate.evaluate(scope)).to be_falsy }
      end

      describe "on x == []" do
        let(:scope){ { :x => [] } }

        it{ expect(predicate.evaluate(scope)).to be_truthy }
      end

      describe "on x == [9]" do
        let(:scope){ { :x => [9] } }

        it{ expect(predicate.evaluate(scope)).to be_truthy }
      end

      describe "on x == [8, 9]" do
        let(:scope){ { :x => [8, 9] } }

        it{ expect(predicate.evaluate(scope)).to be_truthy }
      end

      describe "on x == [8, 9, 10]" do
        let(:scope){ { :x => [8, 9, 19] } }

        it{ expect(predicate.evaluate(scope)).to be_falsy }
      end
    end

    context 'on an subset predicate, with two variables' do
      let(:predicate){
        Predicate.subset(:x, :y)
      }

      describe "on x == [2]" do
        let(:scope){ { :x => [2], :y => [8,9] } }

        it{ expect(predicate.evaluate(scope)).to be_falsy }
      end

      describe "on x == []" do
        let(:scope){ { :x => [], :y => [8,9] } }

        it{ expect(predicate.evaluate(scope)).to be_truthy }
      end

      describe "on x == [9]" do
        let(:scope){ { :x => [9], :y => [8,9] } }

        it{ expect(predicate.evaluate(scope)).to be_truthy }
      end

      describe "on x == [8, 9]" do
        let(:scope){ { :x => [8, 9], :y => [8,9] } }

        it{ expect(predicate.evaluate(scope)).to be_truthy }
      end

      describe "on x == [8, 9, 10]" do
        let(:scope){ { :x => [8, 9, 19], :y => [8,9] } }

        it{ expect(predicate.evaluate(scope)).to be_falsy }
      end
    end

    context 'on an superset predicate, with an array literal' do
      let(:predicate){
        Predicate.superset(:x, [8,9])
      }

      describe "on x == [2]" do
        let(:scope){ { :x => [2] } }

        it{ expect(predicate.evaluate(scope)).to be_falsy }
      end

      describe "on x == []" do
        let(:scope){ { :x => [] } }

        it{ expect(predicate.evaluate(scope)).to be_falsy }
      end

      describe "on x == [9]" do
        let(:scope){ { :x => [9] } }

        it{ expect(predicate.evaluate(scope)).to be_falsy }
      end

      describe "on x == [8, 9]" do
        let(:scope){ { :x => [8, 9] } }

        it{ expect(predicate.evaluate(scope)).to be_truthy }
      end

      describe "on x == [8, 9, 10]" do
        let(:scope){ { :x => [8, 9, 19] } }

        it{ expect(predicate.evaluate(scope)).to be_truthy }
      end
    end

    context 'on an superset predicate, with two variables' do
      let(:predicate){
        Predicate.superset(:x, :y)
      }

      describe "on x == [2]" do
        let(:scope){ { :x => [2], :y => [8,9] } }

        it{ expect(predicate.evaluate(scope)).to be_falsy }
      end

      describe "on x == []" do
        let(:scope){ { :x => [], :y => [8,9] } }

        it{ expect(predicate.evaluate(scope)).to be_falsy }
      end

      describe "on x == [9]" do
        let(:scope){ { :x => [9], :y => [8,9] } }

        it{ expect(predicate.evaluate(scope)).to be_falsy }
      end

      describe "on x == [8, 9]" do
        let(:scope){ { :x => [8, 9], :y => [8,9] } }

        it{ expect(predicate.evaluate(scope)).to be_truthy }
      end

      describe "on x == [8, 9, 10]" do
        let(:scope){ { :x => [8, 9, 19], :y => [8,9] } }

        it{ expect(predicate.evaluate(scope)).to be_truthy }
      end
    end

    context 'on a match against a string' do
      let(:predicate){
        Predicate.match(:x, "12")
      }

      it "matches when expected" do
        [
          { x: 12 },
          { x: "12" },
          { x: "Once upon a time, in 12" },
          { x: "Once upon a time, in 12!" },
        ].each do |tuple|
          expect(predicate.evaluate(tuple)).to be_truthy
        end
      end

      it "does not match when not expected" do
        [
          { x: 17 },
          { x: nil },
          { x: "Londan" },
          { x: "london" },
          { x: "Once upon a time, in Londan" },
          { x: "Once upon a time, in Londan!" },
          { },
          { y: "London" }
        ].each do |tuple|
          expect(predicate.evaluate(tuple)).to be_falsy
        end
      end
    end

    context 'on a match against a string, case insensitive' do
      let(:predicate){
        Predicate.match(:x, "London", case_sensitive: false)
      }

      it "matches when expected" do
        [
          { x: "London" },
          { x: "london" },
          { x: "Once upon a time, in London" },
          { x: "Once upon a time, in London!" },
          { x: "Once upon a time, in london!" },
        ].each do |tuple|
          expect(predicate.evaluate(tuple)).to be_truthy
        end
      end

      it "does not match when not expected" do
        [
          { x: "Londan" },
          { x: "Once upon a time, in Londan" },
          { x: "Once upon a time, in Londan!" },
          { },
          { y: "London" }
        ].each do |tuple|
          expect(predicate.evaluate(tuple)).to be_falsy
        end
      end
    end

    context 'on a match against a regexp' do
      let(:predicate){
        Predicate.match(:x, /London/i)
      }

      it "matches when expected" do
        [
          { x: "London" },
          { x: "london" },
          { x: "Once upon a time, in London" },
          { x: "Once upon a time, in London!" },
          { x: "Once upon a time, in london!" },
        ].each do |tuple|
          expect(predicate.evaluate(tuple)).to be_truthy
        end
      end

      it "does not match when not expected" do
        [
          { x: 17 },
          { x: "Londan" },
          { x: "Once upon a time, in Londan" },
          { x: "Once upon a time, in Londan!" },
          { },
          { y: "London" }
        ].each do |tuple|
          expect(predicate.evaluate(tuple)).to be_falsy
        end
      end
    end

    context 'on a match against a another attribute' do
      let(:predicate){
        Predicate.match(:x, :y)
      }

      it "matches when expected" do
        [
          { x: "London", y: "London" },
          { x: "Once upon a time in London", y: "London" },
        ].each do |tuple|
          expect(predicate.evaluate(tuple)).to be_truthy
        end
      end

      it "does not match when not expected" do
        [
          { x: 17 },
          { x: "Londan", y: "London" },
          { x: "London", y: "Once upon a time in London" },
        ].each do |tuple|
          expect(predicate.evaluate(tuple)).to be_falsy
        end
      end
    end

    context 'when having a placeholder' do
      let(:predicate){
        Predicate.match(:eq, Predicate.placeholder)
      }

      it "raises an UnboundError" do
        expect{ predicate.evaluate({}) }.to raise_error(UnboundError)
      end
    end

    context 'has a call alias' do
      let(:predicate){
        Predicate.new(Factory.gte(:x => 0))
      }

      let(:scope){ { x: 2 } }

      it{ expect(predicate.call(scope)).to be(true) }
    end
  end
end
