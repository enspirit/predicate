class Predicate
  module Func
    include Expr

    def priority
      80
    end

    def left
      self[1]
    end

    def right
      self[2]
    end

    def free_variables
      @free_variables ||= left.free_variables | right.free_variables
    end

    def dyadic_priority
      800
    end

  end
end
