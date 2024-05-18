require 'spec_helper'
class Predicate
  describe Predicate, "free_variables" do

    subject{ p.free_variables }

    describe "on a comp(:eq)" do
      let(:p){ Predicate.coerce(:x => 2) }

      it {
        expect(subject).to eq([:x])
      }
    end

  end
end
