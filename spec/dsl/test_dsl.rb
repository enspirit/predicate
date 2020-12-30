require 'spec_helper'

class Predicate
  describe Dsl do
    subject{
      Predicate::Dsl.new(:x).instance_eval(&bl)
    }

    context 'when used on a comparison op' do
      context 'curried' do
        let(:bl){
          Proc.new{ eq(6) }
        }

        it { expect(subject).to eq(Predicate.eq(:x, 6))}
      end

      context 'non curried' do
        let(:bl){
          Proc.new{ eq(:y, 6) }
        }

        it { expect(subject).to eq(Predicate.eq(:y, 6))}
      end
    end

    context 'when used on between' do
      context 'curried' do
        let(:bl){
          Proc.new{ between(2, 6) }
        }

        it { expect(subject).to eq(Predicate.gte(:x, 2) & Predicate.lte(:x, 6))}
      end

      context 'non curried' do
        let(:bl){
          Proc.new{ between(:y, 2, 6) }
        }

        it { expect(subject).to eq(Predicate.gte(:y, 2) & Predicate.lte(:y, 6))}
      end
    end

    context 'when used on a sugar op' do
      context 'curried' do
        let(:bl){
          Proc.new{ min_size(6) }
        }

        it { expect(subject).to eq(Predicate.has_size(:x, Range.new(6, nil)))}
      end

      context 'curried' do
        let(:bl){
          Proc.new{ min_size(:y, 6) }
        }

        it { expect(subject).to eq(Predicate.has_size(:y, Range.new(6, nil)))}
      end
    end

    context 'when used on match' do
      context 'curryied' do
        let(:bl){
          Proc.new{ match(/a-z/) }
        }

        it { expect(subject).to eq(Predicate.match(:x, /a-z/, {}))}
      end

      context 'curryied with options' do
        let(:bl){
          Proc.new{ match(/a-z/, {case_sensitive: false}) }
        }

        it { expect(subject).to eq(Predicate.match(:x, /a-z/, {case_sensitive: false}))}
      end

      context 'non curried' do
        let(:bl){
          Proc.new{ match(:y, /a-z/) }
        }

        it { expect(subject).to eq(Predicate.match(:y, /a-z/, {}))}
      end

      context 'non curried with options' do
        let(:bl){
          Proc.new{ match(:y, /a-z/, {case_sensitive: false}) }
        }

        it { expect(subject).to eq(Predicate.match(:y, /a-z/, {case_sensitive: false}))}
      end
    end

    context 'when used on size' do
      context 'curried' do
        let(:bl){
          Proc.new{ size(1..10) }
        }

        it { expect(subject).to eq(Predicate.has_size(:x, 1..10))}
      end

      context 'curried with Integer' do
        let(:bl){
          Proc.new{ size(10) }
        }

        it { expect(subject).to eq(Predicate.has_size(:x, 10))}
      end

      context 'not curried' do
        let(:bl){
          Proc.new{ size(:y, 1..10) }
        }

        it { expect(subject).to eq(Predicate.has_size(:y, 1..10))}
      end

      context 'not curried with Integer' do
        let(:bl){
          Proc.new{ size(:y, 10) }
        }

        it { expect(subject).to eq(Predicate.has_size(:y, 10))}
      end
    end

    context 'when used with some camelCase' do
      context 'curried' do
        let(:bl){
          Proc.new{ hasSize(1..10) }
        }

        it { expect(subject).to eq(Predicate.has_size(:x, 1..10))}
      end
    end

    context 'when used with full text versions and their negation' do
      context 'less_than' do
        let(:bl){
          Proc.new{ less_than(:x, 1) }
        }

        it { expect(subject).to eq(Predicate.lt(:x, 1))}
      end

      context 'lessThan' do
        let(:bl){
          Proc.new{ lessThan(:x, 1) }
        }

        it { expect(subject).to eq(Predicate.lt(:x, 1))}
      end

      context 'notLessThan' do
        let(:bl){
          Proc.new{ notLessThan(:x, 1) }
        }

        it { expect(subject).to eq(!Predicate.lt(:x, 1))}
      end
    end

    context 'when used with a negated form' do
      context 'curried' do
        let(:bl){
          Proc.new{ notSize(1..10) }
        }

        it { expect(subject).to eq(!Predicate.has_size(:x, 1..10))}
      end
    end

    context 'when used on null' do
      context 'curried' do
        let(:bl){
          Proc.new{ null() }
        }

        it { expect(subject).to eq(Predicate.eq(:x, nil))}
      end

      context 'negated' do
        let(:bl){
          Proc.new{ notNull() }
        }

        it { expect(subject).to eq(Predicate.neq(:x, nil))}
      end

      context 'not curried' do
        let(:bl){
          Proc.new{ null(:y) }
        }

        it { expect(subject).to eq(Predicate.eq(:y, nil))}
      end
    end

  end
end
