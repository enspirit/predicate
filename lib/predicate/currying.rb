class Predicate
  class Currying

    def initialize(var)
      @var = var
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
      :size,
      #jeny(predicate) :${op_name},
    ].each do |name|
      define_method(name) do |*args|
        m = Factory.instance_method(name)
        args.unshift(@var) if m.arity == 1+args.length
        Predicate.send(name, *args)
      end
    end

  public # Operators with options as last arg

    [
      :match
    ].each do |name|
      define_method(name) do |*args|
        m = Factory.instance_method(name)
        args << {} unless args.last.is_a?(Hash)
        args.unshift(@var) if m.arity == 1+args.length
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
        m = Sugar.instance_method(name)
        args.unshift(@var) if m.arity == 1+args.length
        Predicate.send(name, *args)
      end
    end

  end # class Currying
end # class Predicate
