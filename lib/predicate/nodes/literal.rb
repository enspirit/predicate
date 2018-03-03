class Predicate
  module Literal
    include Expr

    def priority
      100
    end

    def free_variables
      @free_variables ||= []
    end

    def value
      last
    end

  end
end
