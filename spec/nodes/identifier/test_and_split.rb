require 'spec_helper'
class Predicate
  describe Identifier, "and_split" do

    let(:predicate){ Factory.identifier(:id) }
    let(:tautology){ Factory.tautology    }

    subject{ predicate.and_split(list) }

    context 'when included' do
      let(:list){ [:id, :name] }

      it{ should eq([predicate, tautology]) }
    end

    context 'when not include' do
      let(:list){ [:name] }

      it{ should eq([tautology, predicate]) }
    end

  end
end
