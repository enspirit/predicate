require 'spec_helper'
class Predicate
  describe QualifiedIdentifier, "qualified" do

    let(:expr){ Factory.qualified_identifier(:t, :id) }

    subject{ expr.qualifier }

    it {
      expect(subject).to eq(:t)
    }

  end
end
