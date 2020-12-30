class Predicate
  module Sugar

    def min_size(left, right)
      unless right.is_a?(Integer)
        raise ArgumentError, "Integer expected, got #{right}"
      end
      has_size(left, right..)
    end

    def max_size(left, right)
      unless right.is_a?(Integer)
        raise ArgumentError, "Integer expected, got #{right}"
      end
      has_size(left, 0..right)
    end

    #jeny(sugar) def ${op_name}(*args)
    #jeny(sugar)   TODO
    #jeny(sugar) end

  end # module Sugar
end # class Predicate
