require 'spec_helper'
require 'sequel'
require 'sqlite3'
require 'predicate/sequel'
class Predicate
  describe ToSequel do

    DB = Sequel.sqlite

    before(:all) do
      DB.create_table :items do
        primary_key :id
        String :name
        String :address
        Float :price
      end
      items = DB[:items]
    end

    subject do
      DB[:items].where(predicate.to_sequel).sql
    end

    context 'tautology' do
      let(:predicate) { Predicate.tautology }

      it 'works as expected' do
        expect(subject).to eql("SELECT * FROM `items` WHERE (1 = 1)")
      end
    end

    context 'contradiction' do
      let(:predicate) { Predicate.contradiction }

      it 'works as expected' do
        expect(subject).to eql("SELECT * FROM `items` WHERE (1 = 0)")
      end
    end

    context 'eq(name: "bob")' do
      let(:predicate) { Predicate.eq(:name, "Bob") }

      it 'works as expected' do
        expect(subject).to eql("SELECT * FROM `items` WHERE (`name` = 'Bob')")
      end
    end

    context 'eq(name: :address)' do
      let(:predicate) { Predicate.eq(:name, :address) }

      it 'works as expected' do
        expect(subject).to eql("SELECT * FROM `items` WHERE (`name` = `address`)")
      end
    end

    context 'neq(name: "bob")' do
      let(:predicate) { Predicate.neq(:name, "Bob") }

      it 'works as expected' do
        expect(subject).to eql("SELECT * FROM `items` WHERE (`name` != 'Bob')")
      end
    end

    context 'on_dyadic_comp' do
      let(:predicate) { Predicate.lt(:price, 10.0) }

      it 'works as expected' do
        expect(subject).to eql("SELECT * FROM `items` WHERE (`price` < 10.0)")
      end
    end

    context 'in' do
      let(:predicate) { Predicate.in(:price, [10.0, 17.99]) }

      it 'works as expected' do
        expect(subject).to eql("SELECT * FROM `items` WHERE (`price` IN (10.0, 17.99))")
      end
    end

    context 'not' do
      let(:predicate) { !Predicate.in(:price, [10.0, 17.99]) }

      it 'works as expected' do
        expect(subject).to eql("SELECT * FROM `items` WHERE (`price` NOT IN (10.0, 17.99))")
      end
    end

    context 'and' do
      let(:predicate) { Predicate.eq(:name, "Bob") & Predicate.lt(:price, 10.0) }

      it 'works as expected' do
        expect(subject).to eql("SELECT * FROM `items` WHERE ((`name` = 'Bob') AND (`price` < 10.0))")
      end
    end

    context 'or' do
      let(:predicate) { Predicate.eq(:name, "Bob") | Predicate.lt(:price, 10.0) }

      it 'works as expected' do
        expect(subject).to eql("SELECT * FROM `items` WHERE ((`name` = 'Bob') OR (`price` < 10.0))")
      end
    end

    context 'from_hash' do
      let(:predicate) { Predicate.from_hash(name: "Bob", price: [10.0,17.99]) }

      it 'works as expected' do
        expect(subject).to eql("SELECT * FROM `items` WHERE ((`name` = 'Bob') AND (`price` IN (10.0, 17.99)))")
      end
    end

    context 'native' do
      let(:predicate) { Predicate.native(->(t){ false }) }

      it 'raises an error' do
        expect { subject }.to raise_error(NotImplementedError)
      end
    end

  end
end
