class Predicate
  module Intersect
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

    def free_variables
      @free_variables ||= identifier.free_variables
    end

    def constant_variables
      []
    end

    def evaluate(tuple)
      t_x = identifier.evaluate(tuple)
      t_x && !(t_x & values).empty?
    end

  end
end
