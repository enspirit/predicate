class Predicate
  module HasSize
    include BinaryFunc

    def evaluate(tuple)
      l, r = left.evaluate(tuple), right.evaluate(tuple)
      r = r..r if r.is_a?(Integer)
      raise Error, "Expected Range, got #{r}" unless r.is_a?(Range)
      raise Error, "Expected #{l} to respond to :size" unless l.respond_to?(:size)
      r === l.size
    end

  end
end
