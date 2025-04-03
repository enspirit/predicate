class Predicate
  module Empty
    include UnaryFunc

    def evaluate(tuple)
      value = operand.evaluate(tuple)
      unless value.respond_to?(:empty?)
        raise TypeError, "Expected #{value} to respond to empty?"
      end
      value.empty?
    end

    def assert!(tuple, asserter = Asserter.new)
      value = operand.evaluate(tuple)
      asserter.assert_empty(value)
      value
    end

  end
end
