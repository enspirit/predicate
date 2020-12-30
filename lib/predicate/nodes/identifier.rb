class Predicate
  module Identifier
    include Expr

    def priority; 100; end

    def name
      self[1]
    end

    def free_variables
      @free_variables ||= [ name ]
    end

    def evaluate(tuple)
      tuple[name]
    end

  end
end
