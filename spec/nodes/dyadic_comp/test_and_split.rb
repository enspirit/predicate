require 'spec_helper'
class Predicate
  describe DyadicComp, "and_split" do

    let(:predicate){ Factory.eq(:id, 2) }
    let(:tautology){ Factory.tautology  }

    subject{ predicate.and_split(list) }

    context 'when included' do
      let(:list){ [:id, :name] }

      it{ should eq([predicate, tautology]) }
    end

    context 'when not include' do
      let(:list){ [:name] }

      it{ should eq([tautology, predicate]) }
    end

    context 'with attributes on both sides' do
      let(:predicate){ Factory.eq(:x, :y) }

      context 'when full at left' do
        let(:list){ [:x, :y] }
      
        it{ should eq([predicate, tautology]) }
      end
      
      context 'none at left' do
        let(:list){ [] }
      
        it{ should eq([tautology, predicate]) }
      end

      context 'mix' do
        let(:list){ [:y] }

        it{ should eq([predicate, tautology]) }
      end
    end

  end
end
