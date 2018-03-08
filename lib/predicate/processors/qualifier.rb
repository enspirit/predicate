class Predicate
  class Qualifier < Sexpr::Rewriter

    grammar Grammar

    def initialize(qualifier)
      @qualifier = qualifier
    end
    attr_reader :qualifier

    def on_identifier(sexpr)
      case qualifier
      when Symbol
        [:qualified_identifier, qualifier, sexpr.name]
      else
        return sexpr unless q = qualifier[sexpr.name]
        [:qualified_identifier, q, sexpr.name]
      end
    end

    def on_native(sexpr)
      raise NotSupportedError
    end

    alias :on_missing :copy_and_apply

  end
end
