require 'spec_helper'
class Predicate
  describe Identifier, "free_variables" do

    let(:expr){ Factory.identifier(:id) }

    subject{ expr.free_variables }

    it{ should eq([:id]) }

  end
end
