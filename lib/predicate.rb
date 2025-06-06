require 'sexpr'
require_relative 'predicate/version'
require_relative 'predicate/placeholder'
require_relative 'predicate/factory'
require_relative 'predicate/sugar'
require_relative 'predicate/grammar'
require_relative 'predicate/processors'
require_relative 'predicate/dsl'
require_relative 'predicate/asserter'
class Predicate

  class Error < StandardError; end
  class NotSupportedError < Error; end
  class UnboundError < Error; end
  class TypeError < Error; end

  TupleLike = ->(t){ t.is_a?(Hash) }

  SexprLike = ->(x) { x.is_a?(Array) && x.first.is_a?(Symbol) }

  def initialize(sexpr)
    @sexpr = sexpr
  end
  attr_reader :sexpr
  alias :expr :sexpr

  class << self
    include Factory
    include Sugar

    def coerce(arg)
      case arg
      when Predicate   then arg
      when TrueClass   then tautology
      when FalseClass  then contradiction
      when Symbol      then identifier(arg)
      when Proc        then native(arg)
      when Hash        then from_hash(arg)
      else
        raise ArgumentError, "Unable to coerce `#{arg}` to a predicate"
      end
    end
    alias :parse :coerce

    def dsl(var = var(".", :dig), &bl)
      Predicate::Dsl.new(var, false).instance_eval(&bl)
    end

    def currying(var = var(".", :dig), &bl)
      Predicate::Dsl.new(var, true).instance_eval(&bl)
    end

  private

    def _factor_predicate(arg, *mods)
      expr = Grammar.sexpr(arg)
      mods.each do |mod|
        expr.extend(mod)
      end
      Predicate.new(expr)
    end

  end

  def native?
    Native===expr
  end

  def tautology?
    expr.tautology?
  end

  def contradiction?
    expr.contradiction?
  end

  def free_variables
    expr.free_variables
  end

  def constant_variables
    expr.constant_variables
  end

  def constants
    expr.constants
  end

  def &(other)
    return self  if other.tautology? or other==self
    return other if tautology?
    Predicate.new(expr & other.expr)
  end

  def |(other)
    return self  if other.contradiction? or other==self
    return other if contradiction?
    Predicate.new(expr | other.expr)
  end

  def !
    Predicate.new(!expr)
  end

  def qualify(qualifier)
    Predicate.new(expr.qualify(qualifier))
  end

  def unqualify
    Predicate.new(expr.unqualify)
  end

  def rename(renaming)
    Predicate.new(expr.rename(renaming))
  end

  def bind(binding)
    Predicate.new(expr.bind(binding))
  end

  def evaluate(tuple)
    expr.evaluate(tuple)
  end

  def call(tuple)
    expr.evaluate(tuple)
  end

  def assert!(tuple = {})
    expr.assert!(tuple)
  end

  # Splits this predicate, say P, as too predicates P1 & P2
  # such that `P <=> P1 & P2` and P2 makes no reference to
  # any attribute in `attr_list`.
  def and_split(attr_list)
    expr.and_split(attr_list).map{|e| Predicate.new(e)}
  end

  # Returns a hash `(attr -> Pattr)` associating attribute names
  # to predicates, so that each predicate `Pattr` only makes
  # reference to the corresponding attribute name `attr`, while
  # the conjunction of `Pattr`s is still equivalent to the
  # original predicate.
  #
  # A `nil` key may map a predicate that still makes references
  # to more than one attribute.
  def attr_split
    expr.attr_split.each_pair.each_with_object({}) do |(k,v),h|
      h[k] = Predicate.new(v)
    end
  end

  def ==(other)
    other.is_a?(Predicate) && (other.expr==expr)
  end
  alias :eql? :==

  def hash
    expr.hash
  end

  def to_s(scope = nil)
    expr.to_s(scope)
  end

  # If possible, converts this predicate back to a `{ attr: value, ... }`
  # hash.
  #
  # Raises an ArgumentError if the predicate cannot be represented that way.
  def to_hash
    expr.to_hash
  end

  # If possible, converts this predicate back to two `{ attr: value, ... }`
  # hashes, where the first one is positive (e.g. x IN ...) and the second one
  # is negative (e.g. x NOT IN ...)
  #
  # The result is such that the original predicate is equivalent to a AND
  # of the two hashes, where the first includes all its values and the second
  # excludes all its values.
  #
  # Raises an ArgumentError if the predicate cannot be represented that way.
  def to_hashes
    expr.to_hashes
  end

end # class Predicate
