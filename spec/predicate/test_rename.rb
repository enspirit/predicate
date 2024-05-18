require 'spec_helper'
class Predicate
  describe Predicate, "rename" do

    let(:p){ Predicate }

    subject{ predicate.rename(renaming) }

    context 'on a pure renaming hash' do
      let(:renaming) { {:x => :z} }

      context 'on a full AST predicate' do
        let(:predicate){ p.in(:x, [2]) & p.eq(:y, 3) }

        it {
          expect(subject).to eq(p.in(:z, [2]) & p.eq(:y, 3))
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

      context 'on a predicate that contains qualified identifiers' do
        let(:predicate){ p.eq(Factory.qualified_identifier(:t, :x), 3) }

        it 'renames correctly' do
          expect(subject).to eq(p.eq(Factory.qualified_identifier(:t, :z), 3))
        end
      end
    end

    context 'when the renamer is a Proc returning identifiers' do
      let(:renaming){ ->(a){ Grammar.sexpr([:identifier, :y]) } }

      context "on an identifier" do
        let(:predicate){ p.eq(:x, 2) }

        it {
          expect(subject).to eq(p.eq(:y, 2))
        }
      end

      context "on a qualifier identifier" do
        let(:predicate){ p.eq(Factory.qualified_identifier(:t, :x), 2) }

        it {
          expect(subject).to eq(p.eq(:y, 2))
        }
      end
    end

    context 'when the renamer is a Proc returning qualified identifiers' do
      let(:renaming){ ->(a){ Grammar.sexpr([:qualified_identifier, :t, :y]) } }

      context 'on an identifier' do
        let(:predicate){ p.eq(:x, 2) }

        it {
          expect(subject).to eq(p.eq(Factory.qualified_identifier(:t, :y), 2))
        }
      end

      context 'on a qualified' do
        let(:predicate){ p.eq(Factory.qualified_identifier(:t, :x), 2) }

        it {
          expect(subject).to eq(p.eq(Factory.qualified_identifier(:t, :y), 2))
        }
      end
    end

  end
end
