require 'spec_helper'
class Predicate
  describe QualifiedIdentifier, "free_variables" do

    let(:expr){ Factory.qualified_identifier(:t, :id) }

    subject{ expr.free_variables }

    it {
      expect(subject).to eq([:"t.id"])
    }

  end
end
