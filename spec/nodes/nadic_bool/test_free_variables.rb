require 'spec_helper'
class Predicate
  describe NadicBool, "free_variables" do

    subject{ expr.free_variables }

    context "on a complex attribute comparison" do
      let(:expr){ Factory.comp(:neq, :x => :y, :z => 2) }

      it {
        expect(subject).to eq([:x, :y, :z])
      }
    end

  end
end
