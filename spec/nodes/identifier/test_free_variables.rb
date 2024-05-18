require 'spec_helper'
class Predicate
  describe Identifier, "free_variables" do

    let(:expr){ Factory.identifier(:id) }

    subject{ expr.free_variables }

    it {
      expect(subject).to eq([:id])
    }

  end
end
