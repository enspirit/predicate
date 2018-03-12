class Predicate
  module Or
    include NadicBool

    def operator_symbol
      :'||'
    end

    def evaluate(tuple)
      sexpr_body.any?{|op| op.evaluate(tuple) }
    end

  end
end
