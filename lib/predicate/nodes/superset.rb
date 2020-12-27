class Predicate
  module Superset
    include SetOp

    def evaluate(tuple)
      x, y = left.evaluate(tuple), right.evaluate(tuple)
      x && y && (x & y == y)
    end

  end
end
