require 'spec_helper'
class Predicate
  describe Identifier, "and_split" do

    let(:predicate){ Factory.identifier(:id) }
    let(:tautology){ Factory.tautology    }

    subject{ predicate.and_split(list) }

    context 'when included' do
      let(:list){ [:id, :name] }

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
