require_relative 'shared/a_predicate_ast_node'
class Predicate
  describe Factory, 'vars' do
    include Factory

    context 'when used without semantics' do
      subject{ vars("a.b.c", "d.e.f") }

      it 'works as expected' do
        expect(subject).to be_a(Array)
        expect(subject.size).to eql(2)
        expect(subject.all?{|p| p.is_a?(Var) && p.semantics == :dig })
      end
    end

    context 'when used with semantics' do
      subject{ vars("a.b.c", "d.e.f", :jsonpath) }

      it 'works as expected' do
        expect(subject).to be_a(Array)
        expect(subject.size).to eql(2)
        expect(subject.all?{|p| p.is_a?(Var) && p.semantics == :jsonpath })
      end
    end

  end
end
