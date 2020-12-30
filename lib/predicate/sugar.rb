class Predicate
  module Sugar

    [ :eq, :neq, :lt, :lte, :gt, :gte ].each do |m|
      define_method(m) do |left, right=nil|
        return comp(m, left) if TupleLike===left && right.nil?
        super(left, right)
      end
    end

    def between(middle, lower_bound, upper_bound)
      _factor_predicate [:and, [:gte, sexpr(middle), sexpr(lower_bound)],
                               [:lte, sexpr(middle), sexpr(upper_bound)]]
    end

    def match(left, right, options = nil)
      super(left, right, options)
    end

    def min_size(left, right)
      unless right.is_a?(Integer)
        raise ArgumentError, "Integer expected, got #{right}"
      end
      if RUBY_VERSION >= "2.6"
        has_size(left, Range.new(right,nil))
      else
        has_size(left, Range.new(right,(2**32-1)))
      end
    end

    def max_size(left, right)
      unless right.is_a?(Integer)
        raise ArgumentError, "Integer expected, got #{right}"
      end
      has_size(left, 0..right)
    end

    def is_null(operand)
      eq(operand, nil)
    end

    #jeny(sugar) def ${op_name}(*args)
    #jeny(sugar)   TODO
    #jeny(sugar) end

  end # module Sugar
end # class Predicate
