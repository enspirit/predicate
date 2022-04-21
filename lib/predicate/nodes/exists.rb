class Predicate
  module Exists
    include Expr

    def priority; 100; end

    def free_variables
      @free_variables ||= []
    end

    def evaluate(tuple)
      raise NotImplementedError, "Exists#evaluate is not defined"
    end

  end
end
