class Predicate
  module Opaque
    include Expr

    def priority; 100; end

    def free_variables
      @free_variables ||= []
    end

    def evaluate(tuple)
      raise NotImplementedError, "Opaque#evaluate is not defined"
    end

  end
end
