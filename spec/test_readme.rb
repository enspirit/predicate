require 'spec_helper'
require 'ostruct'

describe "README" do

  it 'has a correct first example' do
    p = Predicate.eq(:x, 2) & !Predicate.lte(:y, 3)
    expect(p.evaluate(:x => 2, :y => 6)).to eql(true)
    expect(p.evaluate(:x => 2, :y => 3)).to eql(false)
  end

  it 'has a correct second example' do
    p = Predicate.dsl{
      eq(:x, 2) & !lte(:y, 3)
    }
    expect(p.evaluate(:x => 2, :y => 6)).to eql(true)
    expect(p.evaluate(:x => 2, :y => 3)).to eql(false)
  end

  it 'has a correct third example' do
    p1 = Predicate.gt(:x, 1) & Predicate.lt(:x, 10)
    p2 = Predicate.dsl{
      gt(:x, 1) & lt(:x, 10)
    }
    p3 = Predicate.currying(:x){
      gt(1) & lt(10)
    }
    [p1, p2, p3].all?{|p|
      expect(p.evaluate(:x => 0)).to eql(false)
      expect(p.evaluate(:x => 6)).to eql(true)
      expect(p.evaluate(:x => 22)).to eql(false)
    }
  end

  it 'has a correct fourth example' do
    p = Predicate.currying{
      gt(1) & lt(10)
    }
    expect(p.evaluate(0)).to eql(false)
    expect(p.evaluate(6)).to eql(true)
    expect(p.evaluate(22)).to eql(false)
  end

  it 'has a correct fifth example' do
    x, y = Predicate.vars("items.0.price", "items.1.price")
    p = Predicate.eq(x, 6) & Predicate.lt(y, 10)
    expect(p.evaluate({
      items: [
        { name: "Candy", price: 6 },
        { name: "Crush", price: 4 }
      ]
    })).to eql(true)    
  end

  it 'has a correct sixth example' do
    xyz = Predicate.var([:x, :y, :z], :dig)
    p = Predicate.eq(xyz, 2)
    expect(p.evaluate({ x: { y: { z: 2 } } })).to eql(true)
  end

  it 'has a correct seventh example' do
    class C
      attr_reader :x
      def initialize(x)
        @x = x
      end
    end

    [:send, :public_send].each do |semantics|
      xy = Predicate.var([:x, :y], semantics)
      p = Predicate.eq(xy, 2)
      expect(p.evaluate(C.new(OpenStruct.new(y: 2)))).to eql(true)

      xy = Predicate.var("x.y", semantics)
      p = Predicate.eq(xy, 2)
      expect(p.evaluate(C.new(OpenStruct.new(y: 2)))).to eql(true)
    end
  end

end
