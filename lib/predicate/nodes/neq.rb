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

    def to_hashes
      hash = if left.identifier? && right.literal? && !right.has_placeholder?
        { left.name => right.value }
      elsif right.identifier? && left.literal? && !left.has_placeholder?
        { right.name => left.value }
      else
        super
      end
      [ {}, hash ]
    end

  end
end
