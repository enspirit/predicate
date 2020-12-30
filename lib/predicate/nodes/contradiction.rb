class Predicate
  module Contradiction
    include Expr

    def contradiction?
      true
    end

    def !
      tautology
    end

    def &(other)
      self
    end

    def |(other)
      other
    end

    def dyadic_priority; 1000; end
    def priority; 100; end

    def free_variables
      @free_variables ||= []
    end

    def attr_split
      { nil => self }
    end

    def evaluate(tuple)
      false
    end

  end
end
