class Predicate
  class Currying

    def initialize(var)
      @var = var
    end

    [
      :tautology,
      :contradiction
    ].each do |name|
      define_method(name) do |*args|
        Predicate.send(name)
      end
    end

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
      :between,
      #
      :match,
      :empty,
      :size,
      #jeny(predicate) :${op_name},
    ].each do |name|
      define_method(name) do |*args|
        Predicate.send(name, *args.unshift(@var))
      end
    end

  end # class Currying
end # class Predicate
