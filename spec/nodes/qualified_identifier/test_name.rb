require 'spec_helper'
class Predicate
  describe QualifiedIdentifier, "name" do

    let(:expr){ Factory.qualified_identifier(:t, :id) }

    subject{ expr.name }

    it {
      expect(subject).to eq(:id)
    }

  end
end
