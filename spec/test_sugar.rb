require 'spec_helper'

describe "Predicate.min_size" do
  subject{ Predicate.min_size(:x, 1) }

  it 'works as expected' do
    expect(subject).to eq(Predicate.has_size(:x, 1..))
    expect(subject.call(x: "")).to eq(false)
    expect(subject.call(x: "1")).to eq(true)
  end
end

describe "Predicate.max_size" do
  subject{ Predicate.max_size(:x, 10) }

  it 'works as expected' do
    expect(subject).to eq(Predicate.has_size(:x, 0..10))
    expect(subject.call(x: "")).to eq(true)
    expect(subject.call(x: "01234567891")).to eq(false)
  end
end

#jeny(sugar) describe "Predicate.${op_name}" do
#jeny(sugar)   subject{ Predicate.${op_name}(TODO) }
#jeny(sugar)
#jeny(sugar)   it {
#jeny(sugar)     expect(subject).to eq(TODO)
#jeny(sugar)   }
#jeny(sugar) end
