require 'spec_helper'
class Predicate
  describe Predicate, "qualify" do

    let(:p){ Predicate }

    subject{ predicate.qualify(qualifier) }

    context 'when the qualifier is a Symbol' do
      let(:qualifier) { :t }
      let(:predicate){ p.in(:x, [2]) & p.eq(:y, :z) }

      it 'works as expected' do
        left = p.in(Factory.qualified_identifier(:t, :x), [2])
        right = p.eq(Factory.qualified_identifier(:t, :y), Factory.qualified_identifier(:t, :z))
        expect(subject).to eql(left & right)
      end
    end

    context 'when the qualifier is a Hash' do

      let(:qualifier) { {:x => :t} }

      context 'on a full AST predicate' do
        let(:predicate){ p.in(:x, [2]) & p.eq(:y, 3) }

        it {
          expect(subject).to eq(p.in(Factory.qualified_identifier(:t, :x), [2]) & p.eq(:y, 3))
        }

        specify "it should tag expressions correctly" do
          expect(subject.expr).to be_a(Sexpr)
          expect(subject.expr).to be_a(Expr)
          expect(subject.expr).to be_a(And)
        end
      end

      context 'on a predicate that contains natives' do
        let(:predicate){ p.in(:x, [2]) & p.native(lambda{}) }

        it 'raises an error' do
          expect{
            subject
          }.to raise_error(NotSupportedError)
        end
      end
    end

  end
end
