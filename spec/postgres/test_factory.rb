require 'spec_helper'

class Predicate
  describe 'pg_factory' do

    subject{
      predicate
    }

    let(:predicate) {
      Predicate.tautology
    }

    it_should_behave_like "a predicate"

    context 'pg_array_literal' do
      let(:predicate) do
        Predicate.pg_array_literal([12])
      end
    end

    context 'pg_array_empty' do
      let(:predicate) do
        Predicate.pg_array_empty(:x)
      end
    end

    context 'pg_array_overlaps' do
      let(:predicate) do
        Predicate.pg_array_overlaps(:x, [1,2,3])
      end

      it 'has expected free variables' do
        expect(subject.free_variables).to eql([:x])
      end
    end

    context 'pg_array_overlaps (2)' do
      let(:predicate) do
        Predicate.pg_array_overlaps(:x, :y)
      end

      it 'has expected free variables' do
        expect(subject.free_variables).to eql([:x, :y])
      end
    end
  end
end
