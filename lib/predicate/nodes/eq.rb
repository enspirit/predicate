class Predicate
  module Eq
    include DyadicComp

    def operator_symbol
      :==
    end

    def &(other)
      return super unless free_variables == other.free_variables
      case other
      when Eq
        return self if constants == other.constants
        return contradiction
      when In
        return super unless var_against_literal_value? && other.var_against_literal_value?
        mine, hers = self.right.value, other.right.value
        return self if hers.include?(mine)
        contradiction
      else
        super
      end
    rescue NotSupportedError
      super
    end

    def constant_variables
      fv = free_variables
      fv.size == 1 ? fv : []
    end

    def constants
      left, right = sexpr(self.left), sexpr(self.right)
      if left.identifier? && right.literal? && !right.has_placeholder?
        { left.name => right.value }
      elsif right.identifier? && left.literal? && !left.has_placeholder?
        { right.name => left.value }
      else
        {}
      end
    end

    def dyadic_priority; 900; end

    def evaluate(tuple)
      left.evaluate(tuple) == right.evaluate(tuple)
    end

    def to_hash
      if left.identifier? && right.literal? && !right.has_placeholder?
        { left.name => right.value }
      elsif right.identifier? && left.literal? && !left.has_placeholder?
        { right.name => left.value }
      else
        super
      end
    end

  end
end
