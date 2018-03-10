class Predicate
  module In
    include Expr

    def priority
      80
    end

    def identifier
      self[1]
    end

    def values
      self[2]
    end

    def &(other)
      case other
      when In
        fv = free_variables
        if fv.size == 1 && fv == other.free_variables
          intersection = values & other.values
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
      else
        super
      end
    end

    def free_variables
      @free_variables ||= identifier.free_variables
    end

    def constant_variables
      values.size == 1 ? free_variables : []
    end

    def dyadic_priority
      800
    end

  end
end
