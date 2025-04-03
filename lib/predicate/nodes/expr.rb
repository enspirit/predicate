class Predicate
  module Expr
    include Factory

    OP_NEGATIONS = {
      :eq  => :neq,
      :neq => :eq,
      :lt  => :gte,
      :lte => :gt,
      :gt  => :lte,
      :gte => :lt
    }

    def tautology?
      false
    end

    def contradiction?
      false
    end

    def literal?
      sexpr_type == :literal
    end

    def opaque?
      sexpr_type == :opaque
    end

    def identifier?
      sexpr_type == :identifier
    end

    def !
      sexpr([:not, self])
    end

    def dyadic_priority; 0; end

    def &(other)
      return other if other.contradiction?
      return self  if other.tautology?
      return other & self if other.dyadic_priority > self.dyadic_priority
      sexpr([:and, self, other])
    end

    def |(other)
      return other if other.tautology?
      return self  if other.contradiction?
      sexpr([:or, self, other])
    end

    def assert!(tuple, asserter = Asserter.new)
      asserter.assert(evaluate(tuple))
    end

    def and_split(attr_list)
      # If we have no reference to attr_list, then we are P2, else we are P1
      (free_variables & attr_list).empty? ? [ tautology, self ] : [ self, tautology ]
    end

    def attr_split
      # if I have only one variable reference, then I can return
      # myself mapped to that variable...
      if (vars = free_variables).size == 1
        { vars.first => self }
      else
        # I must still map myself to nil to meet the conjunction
        # specification
        { nil => self }
      end
    end

    def rename(renaming)
      Renamer.call(self, :renaming => renaming)
    end

    def qualify(qualifier)
      Qualifier.new(qualifier).call(self)
    end

    def unqualify
      Unqualifier.new.call(self)
    end

    def bind(binding)
      Binder.new(binding).call(self)
    end

    def constant_variables
      []
    end

    def constants
      {}
    end

    def to_s(scope = nil)
      ToS.call(self, scope: scope)
    end

    def to_hash
      raise ArgumentError, "Unable to represent #{self} to a Hash"
    end

    def to_hashes
      raise ArgumentError, "Unable to represent #{self} to two Hashes"
    end

    def sexpr(arg)
      Factory.sexpr(arg)
    end

  end
end
