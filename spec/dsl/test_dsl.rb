require 'spec_helper'

class Predicate
  describe "The DSL" do
    subject{
      Predicate.currying(:x, &bl)
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

    context 'when used on bewteen' do
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

        it { expect(subject).to eq(Predicate.has_size(:x, 6..))}
      end

      context 'curried' do
        let(:bl){
          Proc.new{ min_size(:y, 6) }
        }

        it { expect(subject).to eq(Predicate.has_size(:y, 6..))}
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
  end
end
