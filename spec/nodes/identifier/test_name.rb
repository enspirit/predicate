require 'spec_helper'
class Predicate
  describe Identifier, "name" do

    let(:expr){ Factory.identifier(:id) }

    subject{ expr.name }

    it{ should eq(:id) }

  end
end
