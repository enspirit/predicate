require 'spec_helper'

describe 'Predicate in a curried form' do

  context 'with a variable name' do
    it 'supports tautology, contradiction' do
      p = Predicate.currying(:x){ tautology }
      expect(p).to eql(Predicate.tautology)

      p = Predicate.currying(:x){ contradiction }
      expect(p).to eql(Predicate.contradiction)
    end

    it 'support comparison operators' do
      p = Predicate.currying(:x){
        gt(0) & lt(12)
      }
      expect(p.evaluate(x: 0)).to be_falsy
      expect(p.evaluate(x: 1)).to be_truthy
      expect(p.evaluate(x: 11)).to be_truthy
      expect(p.evaluate(x: 12)).to be_falsy
    end

    it 'supports between shortcut' do
      p = Predicate.currying(:x){
        between(1, 11)
      }
      expect(p.evaluate(x: 0)).to be_falsy
      expect(p.evaluate(x: 1)).to be_truthy
      expect(p.evaluate(x: 11)).to be_truthy
      expect(p.evaluate(x: 12)).to be_falsy
    end

    it 'supports match' do
      p = Predicate.currying(:x){
        match(/a/)
      }
      expect(p.evaluate(x: "zzz")).to be_falsy
      expect(p.evaluate(x: "abc")).to be_truthy
    end
  end

  context 'without a variable name' do
    it 'applies to the object passed' do
      p = Predicate.currying{
        gt(0) & lt(12)
      }
      expect(p.evaluate(0)).to be_falsy
      expect(p.evaluate(1)).to be_truthy
      expect(p.evaluate(11)).to be_truthy
      expect(p.evaluate(12)).to be_falsy
    end
  end

  context 'on shortcuts' do
    it 'applies to the object passed' do
      p = Predicate.currying{
        min_size(5)
      }
      expect(p.evaluate("1")).to be_falsy
      expect(p.evaluate("013456789")).to be_truthy
    end
  end

end
