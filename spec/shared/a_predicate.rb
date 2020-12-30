shared_examples_for "a predicate" do

  let(:w){ [8, 9] }
  let(:x){ 12 }
  let(:y){ 13 }

  it 'can be negated easily' do
    (!subject).should be_a(Predicate)
  end

  it 'detects stupid AND' do
    (subject & Predicate.tautology).should be(subject)
  end

  it 'detects stupid OR' do
    (subject | Predicate.contradiction).should be(subject)
  end

  it 'has free variables' do
    (fv = subject.free_variables).should be_a(Array)
    (fv - [ :w, :x, :y ]).should be_empty
  end

  it 'always splits around and trivially when no free variables are touched' do
    top, down = subject.and_split([:z])
    top.should be_tautology
    down.should eq(subject)
  end

end
