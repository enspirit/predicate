require 'spec_helper'
class Predicate
  describe Predicate, ".coerce" do

    subject{ Predicate.coerce(arg) }

    describe "from Predicate" do
      let(:arg){ Predicate.new(Factory.tautology) }

      it{ should be(arg) }
    end

    describe "from true" do
      let(:arg){ true }

      specify{
        subject.expr.should be_a(Tautology)
      }
    end

    describe "from false" do
      let(:arg){ false }

      specify{
        subject.expr.should be_a(Contradiction)
      }
    end

    describe "from Symbol" do
      let(:arg){ :status }

      specify{
        subject.expr.should be_a(Identifier)
        subject.expr.name.should eq(arg)
      }
    end

    describe "from Proc" do
      let(:arg){ lambda{ status == 10 } }

      specify{
        subject.expr.should be_a(Native)
        subject.to_proc.should be(arg)
      }
    end

    describe "from String" do
      let(:arg){ "status == 10" }

      it 'raises an error' do
        lambda{
          subject
        }.should raise_error(ArgumentError)
      end
    end

    describe "from Hash (single)" do
      let(:arg){ {status: 10} }

      specify{
        subject.expr.should be_a(Eq)
        subject.expr.should eq([:eq, [:identifier, :status], [:literal, 10]])
      }
    end

    describe "from Hash (multiple)" do
      let(:arg){ {status: 10, name: "Jones"} }

      specify{
        expect(subject).to eq(Predicate.eq(status: 10) & Predicate.eq(name: "Jones"))
      }
    end

    describe "from Hash (in)" do
      let(:arg){ {status: [10, 15]} }

      specify{
        expect(subject).to eq(Predicate.in(:status, [10,15]))
      }
    end

  end
end
