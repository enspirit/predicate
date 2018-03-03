class Predicate
  class ToSequel < Sexpr::Processor

    def on_identifier(sexpr)
      ::Sequel.identifier(sexpr.last)
    end

    def on_qualified_identifier(sexpr)
      ::Sequel.as(sexpr.qualifier, sexpr.name)
    end

    def on_literal(sexpr)
      sexpr.last.nil? ? nil : ::Sequel.expr(sexpr.last)
    end

    ###

    def on_tautology(sexpr)
      ::Sequel::SQL::BooleanConstant.new(true)
    end

    def on_contradiction(sexpr)
      ::Sequel::SQL::BooleanConstant.new(false)
    end

    def on_eq(sexpr)
      left, right = apply(sexpr.left), apply(sexpr.right)
      ::Sequel.expr(left => right)
    end

    def on_neq(sexpr)
      left, right = apply(sexpr.left), apply(sexpr.right)
      ~::Sequel.expr(left => right)
    end

    def on_dyadic_comp(sexpr)
      left, right = apply(sexpr.left), apply(sexpr.right)
      left.send(sexpr.operator_symbol, right)
    end
    alias :on_lt  :on_dyadic_comp
    alias :on_lte :on_dyadic_comp
    alias :on_gt  :on_dyadic_comp
    alias :on_gte :on_dyadic_comp

    def on_in(sexpr)
      left, right = apply(sexpr.identifier), sexpr.last
      ::Sequel.expr(left => right)
    end

    def on_not(sexpr)
      ~apply(sexpr.last)
    end

    def on_and(sexpr)
      body = sexpr.sexpr_body
      body[1..-1].inject(apply(body.first)){|f,t| f & apply(t) }
    end

    def on_or(sexpr)
      body = sexpr.sexpr_body
      body[1..-1].inject(apply(body.first)){|f,t| f | apply(t) }
    end

    def on_native(sexpr)
      raise NotImplementedError
    end

  end # class ToSequel
end # class Predicate
