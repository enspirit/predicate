# Predicate

![](https://travis-ci.com/enspirit/predicate.svg?branch=master)

Boolean (truth-value) expressions that can be evaluated, manipulated,
optimized, translated to code, etc.

## Example(s)

```ruby
# Let's build a simple predicate for 'x = 2 and not(y <= 3)'
p = Predicate.eq(:x, 2) & !Predicate.lte(:y, 3)

p.evaluate(:x => 2, :y => 6)
# => true

p.evaluate(:x => 2, :y => 3)
# => false

p.assert!(:x => 2, :y => 3)
# => Minitest::Assertion("Expected false to be truthy")
```

When building complex expressions, you can use the `dsl` method.

```ruby
# This builds the same predicate
p = Predicate.dsl{
  eq(:x, 2) & !lte(:y, 3)
}
```

The `dsl` block also have all predicates in camelCase, negated, and full text
variants:

```ruby
p = Predicate.dsl{
  notEq(:x, "foo") & hasSize(:y, 1..10) & lessThan(:z, 3)
}
```

If you have complex expressions where many members apply to the same variable,
a `currying` dsl extension is provided. It allows using all `dsl` methods
while omitting their first argument.

```ruby
# Instead of this
p = Predicate.gt(:x, 1) & Predicate.lt(:x, 10)

# or this
p = Predicate.dsl{
  gt(:x, 1) & lt(:x, 10)
}

# do this
p = Predicate.currying(:x){
  gt(1) & lt(10)
}
p.evaluate(:x => 6)
# => true
```

Predicate also works if you want to evaluate an expression on a single object
without having to introduce a variable like `:x`...

```ruby
p = Predicate.currying{
  gt(1) & lt(10)
}
p.evaluate(6)
# => true
```

... or, in contrast, if you want to evaluate boolean expressions over more
complex data structures that a flat Hash like `{:x => 6, ...}`

```ruby
x, y = Predicate.vars("items.0.price", "items.1.price")
p = Predicate.eq(x, 6) & Predicate.lt(y, 10)
p.evaluate({
  items: [
    { name: "Candy", price: 6 },
    { name: "Crush", price: 4 }
  ]
})
# => true
```

The following sections explain a) why we created this library, b) how to build
expressions, c) what operators are available, and d) how abstract variables
work and what features are supported when using them (because not all are).

## Rationale

This reusable library is used in various ruby gems developed and maintained
by Enspirit where boolean expressions are first-class citizen. It provides
a common API for expressing, evaluating, and manipulating them.

* [Bmg](https://github.com/enspirit/bmg)
* [Finitio](https://github.com/blambeau/finitio-rb)
* [Webspicy](https://github.com/enspirit/webspicy)

The library represents an expression as an AST internally. This allows for
subsequent manipulations & reasoning. Please check the `Predicate::Factory`
module for details.

Best-effort simplifications are also performed at construction and when
boolean logic is used (and, or, not). For instance, `eq(:x, 6) & eq(:x, 10)`
yields a `contradiction` predicate. There is currently no way to disable those
simplifications that were initially implemented for `Bmg`.

## Building expressions

The following list of operators is currently available.

### True and False

```ruby
Predicate.tautology                  # aka True
Predicate.contradiction              # aka False
```

### Logical operators

For every valid Predicate instances `p` and `q`:

```ruby
p & q                                # Boolean conjunction
p | q                                # Boolean disjunction
!p                                   # Boolean negation
```

### Comparison operators

```ruby
Predicate.eq(:x, 2)                  # x = 2
Predicate.eq(:x, :y)                 # x = y
Predicate.neq(:x, 2)                 # x != 2
Predicate.neq(:x, :y)                # x != y
Predicate.lt(:x, 2)                  # x < 2
Predicate.lt(:x, :y)                 # x < y
Predicate.lte(:x, 2)                 # x <= 2
Predicate.lte(:x, :y)                # x <= y
Predicate.gt(:x, 2)                  # x > 2
Predicate.gt(:x, :y)                 # x > y
Predicate.gte(:x, 2)                 # x >= 2
Predicate.gte(:x, :y)                # x >= y
```

Shortcuts (translated immediately, no trace kept in AST) :

```ruby
Predicate.eq(x: 2, y: 6)             # eq(:x, 2) & eq(:y, 6)
Predicate.eq(x: 2, y: :z)            # eq(:x, 2) & eq(:y, :z)
# ... and so on for neq, lt, lte, gt, gte

Predicate.between(:x, l, h)          # gte(:x, l) & lte(:x, h), for all l and h
Predicate.in(:x, 1..10)              # gte(:x, 1) & lte(:x, 10)
Predicate.in(:x, 1...10)             # gte(:x, 1) & lt(:x, 10)
#

Predicate.is_null(:x)                # eq(:x, nil)
```

### Set-based operators

```ruby
Predicate.in(:x, [2, 4, 6])          # x ∈ {2, 4, 6}
Predicate.in(:x, :y)                 # x ∈ y
Predicate.intersect(:x, [2, 4, 6])   # x ∩ {2, 4, 6} ≠ ∅
Predicate.intersect(:x, :y)          # x ∩ y ≠ ∅
Predicate.subset(:x, [2, 4, 6])      # x ⊆ {2, 4, 6}
Predicate.subset(:x, :y)             # x ⊆ y
Predicate.superset(:x, [2, 4, 6])    # x ⊇ {2, 4, 6}
Predicate.superset(:x, :y)           # x ⊇ y
```

### Other operators

The following operators have no clear mathematical semantics. Their semantics
depends on the underlying type system. Most are currently not supported outside
of ruby (e.g. SQL compilation). The documentation below applies to a Ruby usage.

```ruby
Predicate.match(:x, /abc/)           # ruby's ===
Predicate.empty(:x)                  # ruby's empty?
Predicate.has_size(:x, 1..10)        # ruby's size and ===
Predicate.has_size(:x, 10)           # Same as has_size(:x, 10..10)
Predicate.has_size(:x, :y)           # y must resolve to a Range or Integer
```

Shortcuts (translated immediately, no trace kept in AST) :

```ruby
Predicate.min_size(:x, 10)           # has_size(:x, 10..)
Predicate.max_size(:x, 10)           # has_size(:x, 0..10)
```

### Native expressions

Ruby `Proc` can be used to capture complex predicates. Native predicates always
receive the top evaluation context as first argument.

```ruby
p = Predicate.native(->(t){
  # t here is the {:x => 2, :y => 6} Hash below
  Foo::Bar.call_to_ruby_code?(t)
})
p.evaluate(:x => 2, :y => 6)
```

Resulting predicates cannot be translated to, e.g. SQL, and typically prevent
optimizations and manipulations:

## Available operators

The following operators are available on predicates.

### Evaluate

`Predicate#evaluate` takes a Hash mapping each free variable to a value,
and returns the Boolean evaluation of the expression.

```ruby
# Let's build a simple predicate for 'x = 2 and not(y <= 3)'
p = Predicate.eq(:x, 2) & !Predicate.lte(:y, 3)

p.evaluate(:x => 2, :y => 6)
# => true
```

### Assert

`Predicate#assert!` takes a takes a Hash mapping each free variable to a value,
and raises a Minitest::AssertionError if the predicate evaluates to false.
A best effort is made to provide readable error messages on the assertion error.

```ruby
# Let's build a simple predicate for 'x = 2 and not(y <= 3)'
p = Predicate.eq(:x, 2) & !Predicate.lte(:y, 3)

p.evaluate(:x => 2, :y => 8)
# => Expected false to be truthy (Minitest::Assertion)
```

### Rename

`Predicate#rename` allows renaming variables.

```ruby
p = Predicate.eq(:x, 4)       # x = 4
p = p.rename(:x => :z)        # z = 4
```

### Bind

`Predicate#bind` allows late binding of placeholders to values.

```ruby
pl = Predicate.placeholder
p = Predicate.eq(:x, pl)      # x = _
p = p.bind(pl, 5)             # x = 5
p.evaluate(:x => 10)
# => false
```

### Quality & Unqualify

`Predicate#qualify` allows adding a qualifier to each variable, for
disambiguation when composing predicates from different contexts.
`Predicate#unqualify` does the opposite.

```ruby
p = Predicate.eq(:x, 2)       # x = 2
p.qualify(:t)                 # t.x = 2
p.unqualify                   # x = 2
```

Qualify accepts a Hash to use different qualifiers for variables.

```ruby
p = Predicate.eq(x: 2, y: 4)  # x = 2 & y = 4
p.qualify(:x => :t, :y => :s)       # t.x = 2 & s.y = 4
```

### And split

`Predicate#and_split` split a predicate `p` as two predicates `p1` and `p2`
so that `p <=> p1 & p2` and `p2` makes no reference to any variable of the
given list.

```ruby
p = Predicate.eq(x: 2, y: 4)  # x = 2 & y = 4
p1, p2 = p.and_split([:x])    # p1 is x = 2 ; p2 is y = 4
```

Observe that `and_split` is always possible but may degenerate to an
uninteresting `p2`, typically when disjunctions are used. For instance,

```ruby
p = Predicate.eq(x: 2) | Predicate.eq(y: 4)  # x = 2 | y = 4
p1, p2 = p.and_split([:x])    # p1 is x = 2 | y = 4 ; p2 is true
```

### Attr split

`Predicate#attr_split` can be used to split a predicate `p` as n+1 predicates
`p1, p2, ..., pn, pz`, such that `p <=> p1 & p2 & ... & pn & pz`. Each
predicate `pi` makes references to variable `i` only, except `pz` which can
reference all of them.

The result is a Hash mapping each variable to its predicate. A `nil` key maps
to `pz`.

```ruby
p = Predicate.eq(x: 2, y: 4)  # x = 2 & y = 4
split = p.attr_split
# => {
#   :x => Predicate.eq(:x, 2),
#   :y => Predicate.eq(:y, 4)
# }
```

## Working with PostgreSQL

(experimental) Predicate supports compiling certain high-level expressions
to PostgreSQL native operators. It works in an direct or indirect way:

```
require 'predicate'
require 'predicate/postgres'

# In direct way, you simply create the predicates using PostgreSQL's own
# operators
p = Predicate.pg_array_overlaps(:x, ['foo', 'bar'])
p.to_sequel

# In indirect way, you use high-level predicates and convert them to
# PostgreSQL later using `to_postgres`
p = Predicate.interect(:x, ['foo', 'bar'])
p = p.to_postgres
p.to_sequel
```

Only a few array operators & translations exist, and only on `varchar[]`
types. Additional support will be added later. The following
translations are implemented (and methods on the right directly available
on the `Predicate` class):

```
          -> pg_array_literal
intersect -> pg_array_overlaps
empty     -> pg_array_empty
```

## Working with abstract variables

WARNING: this `var` feature is only compatible with `Predicate#evaluate`
and `Predicate#bind` so far. Other operators have not been tested and may fail
in unexpected ways or raise a NotImplementedError. Also, predicates using
abstract variables are not properly translated to e.g. SQL.

By default, Predicate expects variable identifiers to be represented by
ruby Symbols. `#evaluate` then takes a mapping between variables and values as
a Hash:

```ruby
# :x and :y are variable identifiers
p = Predicate.eq(:x, 2) & !Predicate.lte(:y, 3)

# the Hash below is a mapping between variables and values
p.evaluate(:x => 2, :y => 6)
# => true
```

There are situations where you would like variables to be kept simple in
expressions while evaluating the latter on complex data structures.

`Predicate#var` can be used as an abstraction mechanism in such cases.
It takes a variable definition as first argument and a semantics as second.
The semantics defines how a value is extracted when the variable value must
be evaluated.

Supported protocols are `:dig`, `:send` and `:public_send`. Only `:dig`
must be considered safe while the two other ones used with great care.

* `:dig` relies on Ruby's `dig` protocol introduced in Ruby 2.3. It
  will work out of the box with Hash, Array, Struct, OpenStruct and
  more generally any object responding to `:dig`:

  ```ruby
  xyz = Predicate.var([:x, :y, :z], :dig)
  p = Predicate.eq(xyz, 2)
  p.evaluate({ :x => { :y => { :z => 2 } } })
  # => true
  ```

  When using `:dig` the variable definition can be passed as a String
  that will be automatically decomposed for you. Variable names are
  transformed to Symbols and integer literals to Integers. You must
  use the explicit version above if you don't want those conversions.

  ```ruby
  # this
  Predicate.var("x.0.y", :dig)

  # is equivalent to
  Predicate.var([:x, 0, :y], :dig)
  ```

* `:send` relies on Ruby's `__send__` method and is generally less
  safe if variable definitions are not strictly controlled. But it
  allows evaluating predicates over any data structure made of pure
  ruby objects:

  ```ruby
  class C
    attr_reader :x
    def initialize(x)
      @x = x
    end
  end

  xy = Predicate.var([:x, :y], :send)
  p = Predicate.eq(xy, 2)
  p.evaluate(C.new(OpenStruct.new(y: 2)))
  # => true
    ```

  The variable can similarly be passed as a dotted String that will be
  decomposed as a sequence of Symbols.

  ```ruby
  xy = Predicate.var("x.y", :send)
  p = Predicate.eq(xy, 2)
  p.evaluate(C.new(OpenStruct.new(y: 2)))
  # => true
  ```

* `:public_send` is similar to `:send` but slightly safer as it only
  allows calling Ruby's public methods.

## Public API

This library follows semantics versioning 2.0. Its public API is:

* Class methods of the `Predicate` class, such as those covered in the
  "Building expressions" section above.

* DSL methods contributed by `Predicate::Factory`, `Predicate::Sugar`,
  and `Predicate::Dsl` modules ; including dynamic ones (negation,
  camelCase, etc.)

* Instance methods of the `Predicate` class, such as those covered in the
  "Available operators" section above.

* Instance and class methods contributed by plugins (e.g. `predicate/sequel`).

* Exception classes: `Predicate::NotSupportedError`,
  `Predicate::UnboundError` and `Predicate::TypeError`.

The AST representation of predicate expressions is NOT part of the public API.
We bump the minor version of the library when it changes, though.

Everything else is condidered private and may change any time (i.e. on patch
releases).

## Contributing

Please use github issues and pull requests, and favor the latter if possible.

This repository uses the help of [jeny](https://github.com/enspirit/jeny) to
generate code snippets when adding new predicates. It supports `predicate`
and `sugar` snippets and add code to be completed in various places:

```
bundle exec jeny s predicate -d op_name:my_predicate -d arity:unary
bundle exec jeny s sugar     -d op_name:my_shortcut
```

## Licence

This software is distributed by Enspirit SRL under a MIT Licence. Please
contact Bernard Lambeau (blambeau@gmail.com) with any question.
