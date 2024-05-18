shared_examples_for "a predicate" do

  let(:w){ [8, 9] }
  let(:x){ 12 }
  let(:y){ 13 }

  it 'is a Predicate' do
    expect(subject).to be_a(Predicate)
  end

  it 'can be negated easily' do
    expect(!subject).to be_a(Predicate)
  end

  it 'detects stupid AND' do
    expect(subject & Predicate.tautology).to be(subject)
  end

  it 'detects stupid OR' do
    expect(subject | Predicate.contradiction).to be(subject)
  end

  it 'has free variables' do
    expect(fv = subject.free_variables).to be_a(Array)
    expect(fv - [ :w, :x, :y ]).to be_empty
  end

  it 'always splits around and trivially when no free variables are touched' do
    top, down = subject.and_split([:z])
    expect(top).to be_tautology
    expect(down).to eq(subject)
  end

end
