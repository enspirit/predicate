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

    context 'qualified eq(name: "bob")' do
      let(:predicate) { Predicate.eq(:name, "Bob").qualify(:t) }

      it 'works as expected' do
        expect(subject).to eql("SELECT * FROM `items` WHERE (`t`.`name` = 'Bob')")
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

    context 'in with nil among values' do
      let(:predicate) { Predicate.in(:price, [nil, 10.0, 17.99]) }

      it 'works as expected' do
        expect(subject).to eql("SELECT * FROM `items` WHERE ((`price` IS NULL) OR (`price` IN (10.0, 17.99)))")
      end
    end

    context 'in with nil among values that can be simplified' do
      let(:predicate) { Predicate.in(:price, [nil, 17.99]) }

      it 'works as expected' do
        expect(subject).to eql("SELECT * FROM `items` WHERE ((`price` IS NULL) OR (`price` = 17.99))")
      end
    end

    context 'in with only nil among values ' do
      let(:predicate) { Predicate.in(:price, [nil]) }

      it 'works as expected' do
        expect(subject).to eql("SELECT * FROM `items` WHERE (`price` IS NULL)")
      end
    end

    context 'in with something responding to sql_literal' do
      let(:operand){
        Object.new.tap{|o|
          def o.sql_literal(db)
            "Hello World"
          end
        }
      }
      let(:predicate) { Predicate.in(:price, Predicate.opaque(operand)) }

      it 'works as expected' do
        expect(subject).to eql("SELECT * FROM `items` WHERE (`price` IN (Hello World))")
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

    context 'intersect' do
      let(:predicate) { Predicate.intersect(:x, [8, 9]) }

      it 'raises an error' do
        expect { subject }.to raise_error(NotSupportedError)
      end
    end

    context 'subset' do
      let(:predicate) { Predicate.subset(:x, [8, 9]) }

      it 'raises an error' do
        expect { subject }.to raise_error(NotSupportedError)
      end
    end

    context 'superset' do
      let(:predicate) { Predicate.superset(:x, [8, 9]) }

      it 'raises an error' do
        expect { subject }.to raise_error(NotSupportedError)
      end
    end

    context 'match' do
      let(:predicate) { Predicate.match(left, right, options) }
      let(:options){ nil }

      context '(attr, String)' do
        let(:left){ :x }
        let(:right){ "London" }

        it 'works as expected' do
          expect(subject).to eql("SELECT * FROM `items` WHERE (`x` LIKE '%London%' ESCAPE '\\')")
        end
      end

      context '(attr, String, case_sensitive: false)' do
        let(:left){ :x }
        let(:right){ "London" }
        let(:options){ { case_sensitive: false } }

        it 'works as expected' do
          expect(subject).to eql("SELECT * FROM `items` WHERE (UPPER(`x`) LIKE UPPER('%London%') ESCAPE '\\')")
        end
      end

      context '(attr, Regexp)' do
        let(:left){ :x }
        let(:right){ /London/i }

        pending 'works as expected' do
          expect(subject).to eql("SELECT * FROM `items` WHERE (`x` LIKE '%London%' ESCAPE '\\')")
        end
      end
    end

    context 'native' do
      let(:predicate) { Predicate.native(->(t){ false }) }

      it 'raises an error' do
        expect { subject }.to raise_error(NotSupportedError)
      end
    end

  end
end
