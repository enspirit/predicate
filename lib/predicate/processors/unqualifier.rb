class Predicate
  class Unqualifier < Sexpr::Rewriter

    grammar Grammar

    def on_qualified_identifier(sexpr)
      [ :identifier, sexpr.last ]
    end

    def on_native(sexpr)
      raise NotSupportedError
    end

    def on_var(sexpr)
      raise NotSupportedError
    end

    alias :on_missing :copy_and_apply

  end
end
