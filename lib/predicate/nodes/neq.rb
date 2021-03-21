class Predicate
  module Neq
    include DyadicComp

    def operator_symbol
      :'!='
    end

    def evaluate(tuple)
      left.evaluate(tuple) != right.evaluate(tuple)
    end

    def assert!(tuple, asserter = Asserter.new)
      l, r = left.evaluate(tuple), right.evaluate(tuple)
      asserter.refute_equal(l, r)
      l
    end

  end
end
