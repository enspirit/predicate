class Predicate
  module Gte
    include DyadicComp

    def operator_symbol
      :>=
    end

    def evaluate(tuple)
      left.evaluate(tuple) >= right.evaluate(tuple)
    end

  end
end
