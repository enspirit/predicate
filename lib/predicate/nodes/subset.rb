class Predicate
  module Subset
    include SetOp

    def evaluate(tuple)
      x, y = left.evaluate(tuple), right.evaluate(tuple)
      x && y && (x & y == x)
    end

  end
end
