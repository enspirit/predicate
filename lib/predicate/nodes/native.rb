class Predicate
  module Native
    include Expr

    def priority
      90
    end

    def proc
      self[1]
    end

    # overriden because parent relies on free_variables,
    # which raises an exception
    def and_split(attr_list)
      # I possibly make references to those attributes, so
      # I can't be P2
      [ self, tautology ]
    end

    # overriden because parent relies on free_variables,
    # which raises an exception
    def attr_split
      { nil => self }
    end

    def evaluate(tuple)
      proc.call(tuple)
    end

    def free_variables
      raise NotSupportedError
    end

  end
end
