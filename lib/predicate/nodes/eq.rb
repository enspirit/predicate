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
        return self if other.right.literal?
      end
      super
    rescue NotSupportedError
      super
    end

    def constant_variables
      fv = free_variables
      fv.size == 1 ? fv : []
    end

    def constants
      left, right = sexpr(self.left), sexpr(self.right)
      if left.identifier? && right.literal?
        { left.name => right.value }
      elsif right.identifier? && left.literal?
        { right.name => left.value }
      else
        {}
      end
    end

    def dyadic_priority
      900
    end

    def evaluate(tuple)
      left.evaluate(tuple) == right.evaluate(tuple)
    end

  end
end
