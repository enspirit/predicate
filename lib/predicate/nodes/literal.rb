class Predicate
  module Literal
    include Expr

    def priority
      100
    end

    def free_variables
      @free_variables ||= []
    end

    def value
      last
    end

    def has_placeholder?
      value.is_a?(Placeholder)
    end

    def empty_value?
      return false if has_placeholder?
      value.respond_to?(:empty?) && value.empty?
    end

    def singleton_value?
      return false if has_placeholder?
      value.respond_to?(:size) && value.size == 1
    end

    def evaluate(tuple)
      raise UnboundError if has_placeholder?
      value
    end

  end
end
