require 'spec_helper'
class Predicate
  describe QualifiedIdentifier, "free_variables" do

    let(:expr){ Factory.qualified_identifier(:t, :id) }

    subject{ expr.free_variables }

    it{ should eq([:"t.id"]) }

  end
end
