class Predicate
  module QualifiedIdentifier
    include Expr

    def priority
      100
    end

    def qualifier
      self[1]
    end

    def name
      self[2]
    end

    def free_variables
      @free_variables ||= [ name ]
    end

  end
end
