class Predicate
  module Intersect
    include SetOp

    def evaluate(tuple)
      x, y = left.evaluate(tuple), right.evaluate(tuple)
      x && y && !(x & y).empty?
    end

  end
end
