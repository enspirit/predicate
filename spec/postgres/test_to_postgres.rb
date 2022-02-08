require 'spec_helper'

class Predicate
  describe 'to_postgres' do
    subject {
      predicate.to_postgres
    }

    context 'on an intersect' do
      let(:predicate){
        Predicate.intersect(:x, [1, 2, 3])
      }

      it 'returns another predicate' do
        expect(subject).to be_a(Predicate)
      end

      it 'replaces intersect by pg_array_overlaps' do
        expect(subject.sexpr).to eql([
          :pg_array_overlaps,
          [ :identifier, :x ],
          [ :pg_array_literal, [1, 2, 3], :varchar ]
        ])
      end
    end

    context 'on an intersect' do
      let(:predicate){
        Predicate.empty(:x)
      }

      it 'replaces empty by pg_array_empty' do
        expect(subject.sexpr).to eql([
          :pg_array_empty,
          [ :identifier, :x ],
          :varchar
        ])
      end
    end
  end
end
