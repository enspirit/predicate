class Predicate
  module Lte
    include DyadicComp

    def operator_symbol
      :<=
    end

    def evaluate(tuple)
      left.evaluate(tuple) <= right.evaluate(tuple)
    end

    def assert!(tuple, asserter = Asserter.new)
      l, r = left.evaluate(tuple), right.evaluate(tuple)
      asserter.assert_operator(l, :<=, r)
      l
    end

  end
end
