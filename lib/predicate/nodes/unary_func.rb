class Predicate
  module UnaryFunc
    include Expr

    def priority; 80; end

    def operand
      self[1]
    end

    def free_variables
      @free_variables ||= operand.free_variables
    end

  end
end
