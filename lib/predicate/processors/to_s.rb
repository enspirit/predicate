class Predicate
  class ToS < Sexpr::Processor

    def on_tautology(sexpr)
      "true"
    end

    def on_contradiction(sexpr)
      "false"
    end

    def on_qualified_identifier(sexpr)
      "#{sexpr.qualifier}.#{sexpr.name}"
    end

    def on_identifier(sexpr)
      if s = options[:scope]
        "#{s}.#{sexpr.last.to_s}"
      else
        "@#{sexpr.last.to_s}"
      end
    end

    def on_not(sexpr)
      "not(" << apply(sexpr.last, sexpr) << ")"
    end

    def on_and(sexpr)
      sexpr.sexpr_body.map{|term|
        apply(term, sexpr)
      }.join(" AND ")
    end

    def on_or(sexpr)
      sexpr.sexpr_body.map{|term|
        apply(term, sexpr)
      }.join(" OR ")
    end

    def on_dyadic(sexpr)
      sexpr.sexpr_body.map{|term|
        apply(term, sexpr)
      }.join(" #{sexpr.operator_symbol} ")
    end
    alias :on_eq  :on_dyadic
    alias :on_neq :on_dyadic
    alias :on_lt  :on_dyadic
    alias :on_lte :on_dyadic
    alias :on_gt  :on_dyadic
    alias :on_gte :on_dyadic

    def on_in(sexpr)
      "#{apply(sexpr.identifier)} IN #{apply(sexpr.right)}"
    end

    def on_intersect(sexpr)
      "#{apply(sexpr.identifier)} INTERSECTS #{to_literal(sexpr.values)}"
    end

    def on_subset(sexpr)
      "#{apply(sexpr.identifier)} IS SUBSET OF #{to_literal(sexpr.values)}"
    end

    def on_superset(sexpr)
      "#{apply(sexpr.identifier)} IS SUPERSET OF #{to_literal(sexpr.values)}"
    end

    def on_literal(sexpr)
      to_literal(sexpr.last)
    end

    def on_opaque(sexpr)
      "OPAQUE #{sexpr.last}"
    end

    def on_match(sexpr)
      "#{apply(sexpr.left)} =~ #{apply(sexpr.right)}"
    end

    #jeny(predicate) def on_${name}(sexpr)
    #jeny(predicate)   "${name}(#{commalist(sexpr.body)})"
    #jeny(predicate) end

    def on_native(sexpr)
      sexpr.last.inspect
    end

    def on_var(sexpr)
      "#{sexpr.semantics}(#{sexpr.formaldef})"
    end

    def on_missing(sexpr)
      raise "Unimplemented: #{sexpr.first}"
    end

  protected

    def commalist(of)
      of.map{|o| apply(o) }.join(',')
    end

    def to_literal(x)
      case x
      when Placeholder then "$#{x.object_id}"
      when Array then "{" << x.map{|y| to_literal(y) }.join(',') << "}"
      else x.inspect
      end
    end

    def apply(sexpr, parent = nil)
      code = super(sexpr)
      if parent && (parent.priority >= sexpr.priority)
        code = "(" << code << ")"
      end
      code
    end

  end
end
