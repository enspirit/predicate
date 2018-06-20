require_relative "shared/a_comparison_factory_method"
class Predicate
  describe Factory, 'in' do

    context 'with values on the right' do
      subject{ Factory.in(:x, [2, 3]) }

      it 'is a In' do
        expect(subject).to be_a(In)
      end

      it 'has the expected AST' do
        expect(subject).to eql([:in, [:identifier, :x], [:literal, [2, 3]]])
      end
    end

    context 'with opaque on the right' do
      subject{ Factory.in(:x, Factory.opaque([2, 3])) }

      it 'is a In' do
        expect(subject).to be_a(In)
      end

      it 'has the expected AST' do
        expect(subject).to eql([:in, [:identifier, :x], [:opaque, [2, 3]]])
      end
    end

  end
end
