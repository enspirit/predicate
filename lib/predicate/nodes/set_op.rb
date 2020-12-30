class Predicate
  module SetOp
    include Expr

    def priority; 80; end

    def left
      self[1]
    end
    alias :identifier :left

    def right
      self[2]
    end
    alias :values :right

    def free_variables
      @free_variables ||= left.free_variables | right.free_variables
    end

    def constant_variables
      []
    end

  end
end
