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

  end
end
