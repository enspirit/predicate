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

    def identifier?
      sexpr_type == :identifier
    end

    def !
      sexpr([:not, self])
    end

    def dyadic_priority
      0
    end

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

    def constant_variables
      []
    end

    def to_ruby_code(scope = 't')
      code = ToRubyCode.call(self, scope: scope)
      "->(t){ #{code} }"
    end

    def to_proc(scope = 't')
      Kernel.eval(to_ruby_code(scope))
    end

    def sexpr(arg)
      Factory.sexpr(arg)
    end

  end
end
