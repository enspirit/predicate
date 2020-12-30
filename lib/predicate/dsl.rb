class Predicate
  class Dsl

    def initialize(var = nil, allow_currying = true)
      @var = var || ::Predicate.var(".", :dig)
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
        ::Predicate.send(name)
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
        ::Predicate.send(name, *args)
      end
    end

  public # Operators with options as last arg

    [
      :match
    ].each do |name|
      define_method(name) do |*args|
        args << {} unless args.last.is_a?(::Hash)
        args = apply_curry(name, args, ::Predicate::Factory)
        ::Predicate.send(name, *args)
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
        args = apply_curry(name, args, ::Predicate::Sugar)
        ::Predicate.send(name, *args)
      end
    end

  public # Extra names

    {
      :size => :has_size,
      :equal => :eq,
      :less_than => :lt,
      :less_than_or_equal => :lte,
      :greater_than => :gt,
      :greater_than_or_equal => :gte
    }.each_pair do |k,v|
      define_method(k) do |*args|
        __send__(v, *args)
      end
    end

  public

    def method_missing(n, *args, &bl)
      snaked, to_negate = missing_method_pair(n)
      if self.respond_to?(snaked)
        got = __send__(snaked.to_sym, *args, &bl)
        to_negate ? !got : got
      else
        super
      end
    end

    def respond_to_missing?(n, include_private = false)
      snaked, to_negate = missing_method_pair(n)
      self.respond_to?(snaked)
    end

  private

    def missing_method_pair(n)
      name, to_negate = n.to_s, false
      if name.to_s[0..2] == "not"
        name, to_negate = name[3..-1], true
      end
      [to_snake_case(name), to_negate]
    end

    def to_snake_case(str)
      str.gsub(/[A-Z]/){|x| "_#{x.downcase}" }.gsub(/^_/, "")
    end

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
