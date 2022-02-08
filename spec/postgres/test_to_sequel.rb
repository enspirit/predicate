require 'spec_helper'
class Predicate
  describe ToSequel do
    PG_DB = Sequel.connect(ENV['PREDICATE_PG_URL'])

    before(:all) do
      create_items_database(PG_DB)
      items = PG_DB[:items]
    end

    subject do
      dataset = PG_DB[:items].where(predicate.to_postgres.to_sequel)
      dataset
    end

    # after do
    #   subject.to_a
    # end

    context 'tautology' do
      let(:predicate) { Predicate.tautology }

      it 'works as expected' do
        expect(subject.sql).to eql(%Q{SELECT * FROM "items" WHERE true})
      end
    end

    context 'intersect' do
      let(:predicate) { Predicate.intersect(:x, [1, 2, 3]) }

      it 'works as expected' do
        expect(subject.sql).to eql(%Q{SELECT * FROM "items" WHERE ("x" && ARRAY[1,2,3])})
      end
    end

    context 'empty' do
      let(:predicate) { Predicate.empty(:x) }

      it 'works as expected' do
        expect(subject.sql).to eql(%Q{SELECT * FROM "items" WHERE ("x" = '{}'::varchar[])})
      end
    end
  end if ENV['PREDICATE_PG_URL']
end
