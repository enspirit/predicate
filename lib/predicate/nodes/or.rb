class Predicate
  module Or
    include NadicBool

    def operator_symbol
      :'||'
    end

    def evaluate(tuple)
      sexpr_body.any?{|op| op.evaluate(tuple) }
    end

    # A disjunction can be represented as a `{ attr => [values] }` hash only
    # when every operand constrains the *same single* attribute to a literal
    # or a set of literals, e.g. `x == 1 OR x == 2 OR x IN [3, 4]`. Operands
    # are folded together into an IN-style hash. As soon as an operand touches
    # another attribute, or cannot itself be represented as a hash, the whole
    # disjunction is not representable and an ArgumentError is raised (as for
    # any other non-representable predicate).
    def to_hash
      merged = sexpr_body.inject(nil) do |acc, term|
        hash = term.to_hash
        return super unless hash.size == 1

        attr, value = hash.first
        values = value.is_a?(Array) ? value : [value]

        if acc.nil?
          [attr, values.dup]
        elsif acc.first == attr
          [attr, acc.last + values]
        else
          return super
        end
      end

      return super if merged.nil?
      { merged.first => merged.last.uniq }
    end

    def to_hashes
      [ to_hash, {} ]
    end

  end
end
