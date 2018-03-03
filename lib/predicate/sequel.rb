class Predicate

  module Expr

    def to_sequel
      ToSequel.call(self)
    end

  end # module Expr

  def to_sequel
    expr.to_sequel
  end

end # class Predicate
require_relative 'sequel/to_sequel'
