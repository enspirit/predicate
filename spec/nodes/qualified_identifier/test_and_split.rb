require 'spec_helper'
class Predicate
  describe QualifiedIdentifier, "and_split" do

    let(:predicate){ Factory.qualified_identifier(:t, :id) }
    let(:tautology){ Factory.tautology    }

    subject{ predicate.and_split(list) }

    context 'when included' do
      let(:list){ [:"t.id", :name] }

      it{ should eq([predicate, tautology]) }
    end

    context 'when not include' do
      let(:list){ [:name] }

      it{ should eq([tautology, predicate]) }
    end

  end
end
