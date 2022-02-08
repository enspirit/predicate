class Predicate
  module Factory

  public # Boolean

    # Factors a Predicate that captures True
    def tautology
      _factor_predicate([:tautology, true])
    end

    # Factors a Predicate that captures False
    def contradiction
      _factor_predicate([:contradiction, false])
    end

  public # Literals

    # Factors a Literal node for some ruby value.
    def literal(literal)
      _factor_predicate([:literal, literal])
    end

  public # Vars & identifiers

    # Factors a var node, using a given extractor semantics
    def var(formaldef, semantics = :dig)
      _factor_predicate([:var, formaldef, semantics])
    end

    # Factors a couple of variables at once. The semantics can
    # be passed as a Symbol as last argument and defaults to :dig
    def vars(*args)
      args << :dig unless args.last.is_a?(Symbol)
      args[0...-1].map{|v| var(v, args.last) }
    end

    # Factors a Predicate for a free variable whose
    # name is provided. If the variable is a Boolean
    # variable, this is a valid Predicate, otherwise
    # it must be used in a higher-level expression.
    def identifier(name)
      _factor_predicate([:identifier, name])
    end

    # Factors a Predicate for a qualified free variable.
    # Same remark as in `identifier`.
    def qualified_identifier(qualifier, name)
      _factor_predicate([:qualified_identifier, qualifier, name])
    end

    # Builds and returns a placeholder that can be used
    # everywhere a literal can be used. Placeholders can
    # be bound later, using `Predicate#bind`.
    def placeholder
      Placeholder.new
    end

  public # Boolean logic

    # Builds a AND predicate using two sub predicates.
    #
    # Please favor `Predicate#&` instead.
    def and(left, right = nil)
      _factor_predicate([:and, sexpr(left), sexpr(right)])
    end

    # Builds a OR predicate using two sub predicates.
    #
    # Please favor `Predicate#|` instead.
    def or(left, right = nil)
      _factor_predicate([:or, sexpr(left), sexpr(right)])
    end

    # Negates an existing predicate.
    #
    # Please favor `Predicate#!` instead.
    def not(operand)
      _factor_predicate([:not, sexpr(operand)])
    end

  public # Comparison operators

    # :nodoc:
    def comp(op, h)
      from_hash(h, op)
    end

    # Factors =, !=, <, <=, >, >= predicates between
    # a variable and either a literal or another variable.
    [ :eq, :neq, :lt, :lte, :gt, :gte ].each do |m|
      define_method(m) do |left, right|
        _factor_predicate([m, sexpr(left), sexpr(right)])
      end
    end

  # Set operators

    # Factors a IN predicate between a variable and
    # either a list of values of another variable.
    def in(left, right)
      case right
      when Range
        return contradiction if right.size == 0
        rl = gte(left, right.begin)
        rr = right.exclude_end? ? lt(left, right.end) : lte(left, right.end)
        self.and(rl, rr)
      else
        left, right = sexpr(left), sexpr(right)
        if right.literal? && right.empty_value?
          contradiction
        else
          _factor_predicate([:in, left, right])
        end
      end
    end
    alias :among :in

    # Factors an INTERSECT predicate between a
    # variable and a list of values.
    [:intersect, :subset, :superset].each do |name|
      define_method(name) do |left, right|
        identifier = sexpr(identifier) if identifier.is_a?(Symbol)
        _factor_predicate([name, sexpr(left), sexpr(right)])
      end
    end

  public # Other operators

    # Factors a MATCH predicate between a variable
    # and a literal or another variable.
    #
    # Matching options can be passes and are specific
    # to the actual usage of the library.
    def match(left, right, options)
      s = [:match, sexpr(left), sexpr(right)]
      s << options unless options.nil?
      _factor_predicate(s)
    end

    # Factors an EMPTY predicate that responds true
    # when its operand is something empty.
    #
    # Default evaluation uses ruby `empty?` method.
    def empty(operand)
      _factor_predicate([:empty, sexpr(operand)])
    end

    # Factors a SIZE predicate that responds true when
    # its operand has a size meeting the right constraint
    # (typically a Range literal)
    def has_size(left, right)
      _factor_predicate([:has_size, sexpr(left), sexpr(right)])
    end

    #jeny(predicate) # TODO
    #jeny(predicate) def ${op_name}(*args)
    #jeny(predicate)   args = args.map{|arg| sexpr(arg) }
    #jeny(predicate)   _factor_predicate([:${op_name}] + args)
    #jeny(predicate) end

  public # Low-level

    # Factors a predicate from a mapping between variables
    # and values. This typically generates a AND(EQ)
    # predicate, but a value can be an Array (IN) or a
    # Regexp (MATCH).
    def h(h)
      from_hash(h, :eq)
    end

    # Factors a predicate for a ruby Proc that returns
    # truth-value for a single argument.
    def native(arg)
      _factor_predicate([:native, arg])
    end

    # Converts `arg` to an opaque predicate, whose semantics
    # depends on the actual usage of the library.
    def opaque(arg)
      _factor_predicate([:opaque, arg])
    end

  public # Semi protected

    # Builds a AND predicate between all key/value pairs
    # of the provided Hash, using the comparison operator
    # specified.
    def from_hash(h, op = :eq)
      if h.empty?
        tautology
      else
        terms = h.to_a.map{|(k,v)|
          case v
          when Array  then [:in, sexpr(k), sexpr(v)]
          when Regexp then [:match, sexpr(k), sexpr(v) ]
          else             [op, sexpr(k), sexpr(v)]
          end
        }
        terms = terms.size == 1 ? terms.first : terms.unshift(:and)
        _factor_predicate terms
      end
    end

  public

    def sexpr(expr)
      case expr
      when Expr        then expr
      when Predicate   then expr.expr
      when TrueClass   then Grammar.sexpr([:tautology, true])
      when FalseClass  then Grammar.sexpr([:contradiction, false])
      when Symbol      then Grammar.sexpr([:identifier, expr])
      when Proc        then Grammar.sexpr([:native, expr])
      when SexprLike   then Grammar.sexpr(expr)
      else
        Grammar.sexpr([:literal, expr])
      end
    end

    def _factor_predicate(arg, *mods)
      expr = sexpr(arg)
      mods.each do |mod|
        expr.extend(mod)
      end
      expr
    end

    extend(self)
  end # module Factory
end # class Predicate
