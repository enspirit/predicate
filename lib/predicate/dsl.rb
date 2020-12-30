class Predicate
  class Dsl

    def initialize(var, allow_currying = true)
      @var = var
      @allow_currying = allow_currying
    end

  public # No injection

    [
      :tautology,
      :contradiction,
      :literal,
      :var,
      :vars,
      :identifier,
      :qualified_identifier,
      :placeholder
    ].each do |name|
      define_method(name) do |*args|
        Predicate.send(name)
      end
    end

  public # All normal

    [
      :in,
      :intersect,
      :subset,
      :superset,
      #
      :eq,
      :neq,
      :lt,
      :lte,
      :gt,
      :gte,
      #
      :empty,
      :has_size,
      #jeny(predicate) :${op_name},
    ].each do |name|
      define_method(name) do |*args|
        args = apply_curry(name, args, Factory)
        Predicate.send(name, *args)
      end
    end

  public # Operators with options as last arg

    [
      :match
    ].each do |name|
      define_method(name) do |*args|
        args << {} unless args.last.is_a?(Hash)
        args = apply_curry(name, args, Factory)
        Predicate.send(name, *args)
      end
    end

  public # Sugar operators

    [
      :between,
      :min_size,
      :max_size,
      #jeny(sugar) :${op_name},
    ].each do |name|
      define_method(name) do |*args|
        args = apply_curry(name, args, Sugar)
        Predicate.send(name, *args)
      end
    end

  private

    def apply_curry(name, args, on)
      m = on.instance_method(name)
      if @allow_currying and m.arity == 1+args.length
        [@var] + args
      else
        args
      end
    end

  end # class Dsl
end # class Predicate
