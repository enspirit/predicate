require 'spec_helper'
class Predicate
  describe QualifiedIdentifier, "and_split" do

    let(:predicate){ Factory.qualified_identifier(:t, :id) }
    let(:tautology){ Factory.tautology    }

    subject{ predicate.and_split(list) }

    context 'when included' do
      let(:list){ [:"t.id", :name] }

      it {
        expect(subject).to eq([predicate, tautology])
      }
    end

    context 'when not include' do
      let(:list){ [:name] }

      it {
        expect(subject).to eq([tautology, predicate])
      }
    end

  end
end
