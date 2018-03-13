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

    context 'on an intersect predicate' do
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

  end
end
