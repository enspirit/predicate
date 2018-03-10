class Predicate
  module Eq
    include DyadicComp

    def operator_symbol
      :==
    end

    def &(other)
      case other
      when Eq
        if free_variables == other.free_variables
          return self if constants == other.constants
          contradiction
        else
          super
        end
      when In
        return self if free_variables == other.free_variables
        super
      else
        super
      end
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

  end
end
