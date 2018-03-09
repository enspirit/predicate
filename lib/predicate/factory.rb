class Predicate
  module Factory

    def tautology
      _factor_predicate([:tautology, true])
    end

    def contradiction
      _factor_predicate([:contradiction, false])
    end

    def identifier(name)
      _factor_predicate([:identifier, name])
    end

    def qualified_identifier(qualifier, name)
      _factor_predicate([:qualified_identifier, qualifier, name])
    end

    def and(left, right = nil)
      _factor_predicate([:and, sexpr(left), sexpr(right)])
    end

    def or(left, right = nil)
      _factor_predicate([:or, sexpr(left), sexpr(right)])
    end

    def not(operand)
      _factor_predicate([:not, sexpr(operand)])
    end

    def in(identifier, values)
      identifier = sexpr(identifier) if identifier.is_a?(Symbol)
      _factor_predicate([:in, identifier, values])
    end
    alias :among :in

    def intersect(identifier, values)
      identifier = sexpr(identifier) if identifier.is_a?(Symbol)
      _factor_predicate([:intersect, identifier, values])
    end

    def comp(op, h)
      from_hash(h, op)
    end

    [ :eq, :neq, :lt, :lte, :gt, :gte ].each do |m|
      define_method(m) do |left, right=nil|
        return comp(m, left) if TupleLike===left && right.nil?
        _factor_predicate([m, sexpr(left), sexpr(right)])
      end
    end

    def between(middle, lower_bound, upper_bound)
      _factor_predicate [:and, [:gte, sexpr(middle), sexpr(lower_bound)],
                               [:lte, sexpr(middle), sexpr(upper_bound)]]
    end

    def from_hash(h, op = :eq)
      if h.empty?
        tautology
      else
        terms = h.to_a.map{|(k,v)|
          if v.is_a?(Array)
            [:in, sexpr(k), v]
          else
            [op, sexpr(k), sexpr(v)]
          end
        }
        terms = terms.size == 1 ? terms.first : terms.unshift(:and)
        _factor_predicate terms
      end
    end

    def literal(literal)
      _factor_predicate([:literal, literal])
    end

    def native(arg)
      _factor_predicate([:native, arg])
    end

  protected

    def sexpr(expr)
      case expr
      when Expr       then expr
      when Predicate  then expr.expr
      when TrueClass  then Grammar.sexpr([:tautology, true])
      when FalseClass then Grammar.sexpr([:contradiction, false])
      when Symbol     then Grammar.sexpr([:identifier, expr])
      when Proc       then Grammar.sexpr([:native, expr])
      when Array      then Grammar.sexpr(expr)
      else
        Grammar.sexpr([:literal, expr])
      end
    end

    def _factor_predicate(arg)
      sexpr(arg)
    end

    extend(self)
  end # module Factory
end # class Predicate
