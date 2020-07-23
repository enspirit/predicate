class Predicate
  module Tautology
    include Expr

    def tautology?
      true
    end

    def !
      contradiction
    end

    def &(other)
      other
    end

    def |(other)
      self
    end

    def dyadic_priority
      1000
    end

    def priority
      100
    end

    def free_variables
      @free_variables ||= []
    end

    def attr_split
      {}
    end

    def evaluate(tuple)
      true
    end

    def to_hash
      {}
    end

  end
end
