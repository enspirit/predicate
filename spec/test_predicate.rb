require 'spec_helper'

describe 'Predicate.tautology' do
  subject{ Predicate.tautology }

  it_should_behave_like "a predicate"
end

describe 'Predicate.contradiction' do
  subject{ Predicate.contradiction }

  it_should_behave_like "a predicate"
end

describe "Predicate.comp" do
  subject{ Predicate.comp(:lt, {:x => 2}) }

  it_should_behave_like "a predicate"
end

describe "Predicate.in, with a list" do
  subject{ Predicate.in(:x, [2, 3]) }

  it_should_behave_like "a predicate"

  it 'should lead to a contradiction if value list is empty' do
    expect(Predicate.in(:x, [])).to eql(Predicate.contradiction)
  end
end

describe "Predicate.in, with an inclusive range" do
  subject{ Predicate.in(:x, 1..10) }

  it_should_behave_like "a predicate"

  it 'should be a shortcut over comparisons' do
    expect(subject).to eql(Predicate.gte(:x, 1) & Predicate.lte(:x, 10))
  end
end

describe "Predicate.in, with an exclusive range" do
  subject{ Predicate.in(:x, 1...10) }

  it_should_behave_like "a predicate"

  it 'should be a shortcut over comparisons' do
    expect(subject).to eql(Predicate.gte(:x, 1) & Predicate.lt(:x, 10))
  end
end

describe "Predicate.in, with an empty range" do
  subject{ Predicate.in(:x, 1...1) }

  it_should_behave_like "a predicate"

  it 'should be a contradiction' do
    expect(subject).to eql(Predicate.contradiction)
  end
end

describe "Predicate.among" do
  subject{ Predicate.among(:x, [2, 3]) }

  it_should_behave_like "a predicate"
end

describe "Predicate.intersect" do
  subject{ Predicate.intersect(:x, [2, 3]) }

  it_should_behave_like "a predicate"
end

describe "Predicate.subset" do
  subject{ Predicate.subset(:x, [2, 3]) }

  it_should_behave_like "a predicate"
end

describe "Predicate.superset" do
  subject{ Predicate.superset(:x, [2, 3]) }

  it_should_behave_like "a predicate"
end

describe "Predicate.eq" do
  subject{ Predicate.eq(:x, 2) }

  it_should_behave_like "a predicate"
end

describe "Predicate.neq" do
  subject{ Predicate.neq(:x, 2) }

  it_should_behave_like "a predicate"
end

describe "Predicate.gt" do
  subject{ Predicate.gt(:x, 2) }

  it_should_behave_like "a predicate"
end

describe "Predicate.gte" do
  subject{ Predicate.gte(:x, 2) }

  it_should_behave_like "a predicate"
end

describe "Predicate.lt" do
  subject{ Predicate.lt(:x, 2) }

  it_should_behave_like "a predicate"
end

describe "Predicate.lte" do
  subject{ Predicate.lte(:x, 2) }

  it_should_behave_like "a predicate"
end

describe "Predicate.between" do
  subject{ Predicate.between(:x, 2, 3) }

  it_should_behave_like "a predicate"
end

describe "Predicate.and" do
  subject{ Predicate.and(Predicate.eq(:x, 12), Predicate.eq(:y, 12)) }

  it_should_behave_like "a predicate"

  it 'detects contraditions' do
    p1 = Predicate.in(:a, [10,11])
    p2 = Predicate.eq(:a, 7)
    expect(p1 & p2).to eq(Predicate.contradiction)
  end
end

describe "Predicate.or" do
  subject{ Predicate.or(Predicate.eq(:x, 12), Predicate.eq(:y, 12)) }

  it_should_behave_like "a predicate"
end

describe "Predicate.not" do
  subject{ Predicate.not(Predicate.in(:x, [12])) }

  it_should_behave_like "a predicate"
end

describe "Predicate.dsl" do
  subject{ Predicate.dsl{ eq(:x, 6) & lte(:y, 5)} }

  it_should_behave_like "a predicate"
end

describe "Predicate.empty" do
  subject{ Predicate.empty(:x) }

  it_should_behave_like "a predicate"
end

describe "Predicate.has_size" do
  subject{ Predicate.has_size(:x, 1..10) }

  it_should_behave_like "a predicate"
end

#jeny(predicate) describe "Predicate.${op_name}" do
#jeny(predicate)   subject{ Predicate.${op_name}(TODO) }
#jeny(predicate)
#jeny(predicate)   it_should_behave_like "a predicate"
#jeny(predicate) end
