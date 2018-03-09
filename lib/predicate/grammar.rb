class Predicate
  Grammar = Sexpr.load File.expand_path('../grammar.sexp.yml', __FILE__)
  module Grammar

    def tagging_reference
      Predicate
    end

    def default_tagging_module
      Expr
    end

  end
end # class Predicate
require_relative 'nodes/expr'
require_relative 'nodes/dyadic_comp'
require_relative 'nodes/nadic_bool'
require_relative 'nodes/tautology'
require_relative 'nodes/contradiction'
require_relative 'nodes/identifier'
require_relative 'nodes/qualified_identifier'
require_relative 'nodes/and'
require_relative 'nodes/or'
require_relative 'nodes/not'
require_relative 'nodes/eq'
require_relative 'nodes/neq'
require_relative 'nodes/gt'
require_relative 'nodes/gte'
require_relative 'nodes/lt'
require_relative 'nodes/lte'
require_relative 'nodes/in'
require_relative 'nodes/intersect'
require_relative 'nodes/literal'
require_relative 'nodes/native'
