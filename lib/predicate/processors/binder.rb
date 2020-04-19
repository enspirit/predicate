class Predicate
  class Binder < Sexpr::Rewriter

    grammar Grammar

    def initialize(binding)
      @binding = binding
    end
    attr_reader :binding

    def on_literal(sexpr)
      lit = sexpr.last
      if lit.is_a?(Placeholder)
        [:literal, binding[lit]]
      else
        sexpr
      end
    end

    alias :on_missing :copy_and_apply

  end
end
