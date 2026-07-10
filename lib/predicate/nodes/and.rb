class Predicate
  module And
    include NadicBool

    def operator_symbol
      :'&&'
    end

    def &(other)
      return contradiction if in_contradiction?(self, other)

      case other
      when Tautology     then self
      when Contradiction then other
      when And           then sexpr(dup + other[1..-1])
      else               dup << other
      end
    end

    def and_split(attr_list)
      # Say we are X = X1 & X2 & X3
      # We will split each term: X = (X1 & Y1) & (X2 & Y2) & (X3 & Y3)
      # ... such that Y1, Y2, and Y2 makes no reference to attr_list
      # ... which is equivalent to (X1 & X2 & X3) & (Y1 & Y2 & Y3)
      # ... hence P1 & P2, that we return
      sexpr_body.inject([tautology, tautology]) do |(top,down),term|
        p1, p2 = term.and_split(attr_list)
        [top & p1, down & p2]
      end
    end

    def attr_split
      # Similar to and_split above, but the reasonning applies on
      # attribute names this time.
      sexpr_body.each_with_object({}) do |term, h|
        term.attr_split.each_pair do |a,p|
          h[a] = (h[a] || tautology) & p
        end
      end
    end

    def constant_variables
      sexpr_body.inject([]) do |cvars,expr|
        cvars | expr.constant_variables
      end
    end

    def constants
      sexpr_body.each_with_object({}) do |op, cs|
        cs.merge!(op.constants){|k,v1,v2| v1 }
      end
    end

    def evaluate(tuple)
      sexpr_body.all?{|operand| operand.evaluate(tuple) }
    end

    def assert!(tuple, asserter = Asserter.new)
      sexpr_body.all?{|operand| operand.assert!(tuple, asserter) }
    end

    def to_hash
      sexpr_body.inject({}) do |p,term|
        _hash_merge(p, term.to_hash)
      end
    end

    def to_hashes
      sexpr_body.inject([{},{}]) do |(pos,neg),term|
        t_pos, t_neg = term.to_hashes
        [
          _hash_merge(pos, t_pos),
          _hash_merge(neg, t_neg)
        ]
      end
    end

    def _hash_merge(h1, h2)
      h1.merge(h2){|k,v1,v2|
        raise ArgumentError, "Unable to represent #{self} to a Hash" unless v1 == v2
        v1
      }
    end

  end
end
