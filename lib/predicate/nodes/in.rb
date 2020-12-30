class Predicate
  module In
    include Expr

    def priority; 80; end

    def left
      self[1]
    end
    alias :identifier :left

    def right
      self[2]
    end

    def &(other)
      case other
      when Eq
        other & self
      when In
        # we only optimize is same free variables
        fv = free_variables
        return super unless fv.size == 1 && fv == other.free_variables

        # we only optimize if both right terms are literals
        return super unless right.literal? and other.right.literal?
        return super if right.has_placeholder? or other.right.has_placeholder?

        intersection = right.value & other.right.value
        if intersection.empty?
          Factory.contradiction
        elsif intersection.size == 1
          Factory.eq(fv.first, [:literal, intersection.first])
        else
          Factory.in(fv.first, intersection)
        end
      else
        super
      end
    end

    def free_variables
      @free_variables ||= identifier.free_variables
    end

    def constant_variables
      if right.literal? and right.singleton_value?
        free_variables
      else
        []
      end
    end

    def constants
      if right.literal? and right.singleton_value?
        { identifier.name => right.value.first }
      else
        {}
      end
    end

    def dyadic_priority; 800; end

    def evaluate(tuple)
      values = right.evaluate(tuple)
      raise UnboundError if values.is_a?(Placeholder)
      values.include?(identifier.evaluate(tuple))
    end

    def var_against_literal_value?
      left.identifier? && right.literal? && !right.has_placeholder?
    end

    def to_hash
      return super unless var_against_literal_value?
      { identifier.name => right.value }
    end

  end
end
