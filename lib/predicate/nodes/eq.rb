class Predicate
  module Eq
    include DyadicComp

    def operator_symbol
      :==
    end

    def constant_variables
      fv = free_variables
      fv.size == 1 ? fv : []
    end

  end
end
