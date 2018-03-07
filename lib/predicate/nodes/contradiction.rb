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

    def priority
      100
    end

    def free_variables
      @free_variables ||= []
    end

  end
end
