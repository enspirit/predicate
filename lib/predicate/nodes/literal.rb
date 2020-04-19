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
      case value
      when Placeholder
        false
      else
        value.respond_to?(:empty?) && value.empty?
      end
    end

    def singleton_value?
      case value
      when Placeholder
        false
      else
        value.respond_to?(:size) && value.size == 1
      end
    end

    def evaluate(tuple)
      value
    end

  end
end
