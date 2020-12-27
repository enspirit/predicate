# Predicate

Boolean (truth-value) expressions that can be evaluated, manipulated,
optimized, translated to code, etc.

## Example

```ruby
# Let's build a simple predicate for 'x = 2 and not(y <= 3)'
p = Predicate.eq(:x, 2) & !Predicate.lte(:y, 3)

p.evaluate(x: 2, y: 6)
# => true

p.evaluate(x: 2, y: 3)
# => false
```

When building complex expressions, you can use the `dsl` method.

```ruby
# This builds the same predicate
p = Predicate.dsl{
  eq(:x, 2) & !lte(:y, 3)
}
```

If you have complex expressions with many members applying to the
same variable, a `currying` dsl is provided.

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

```

## Rationale

This reusable library is used in various ruby gems developed and maintained
by Enspirit, where boolean expressions are first-class citizen. It provides
a common API for expressing, evaluating, and manipulating them.

* [Bmg](https://github.com/enspirit/bmg)
* [Finitio](https://github.com/blambeau/finitio-rb)
* [Webspicy](https://github.com/enspirit/webspicy)

The library represents an expression as an AST internally. This allows for
subsequent manipulations & reasoning. Please check the `Predicate::Factory`
module for details.

Some best-effort simplifications are also performed at construction and when
boolean logic is used (and, or, not). For instance, `eq(:x, 6) & eq(:x, 10)`
yields a `contradiction` predicate. There is currently no way to disable those
simplifications, that were initially implemented for `Bmg`.

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
Predicate.eq(x: 2, y: 6)             # Shortcut for eq(:x, 2) & eq(:y, 6)
Predicate.eq(x: 2, y: :z)            # Shortcut for eq(:x, 2) & eq(:y, :z)
# ... and so on for neq, lt, lte, gt, gte

Predicate.between(:x, l, h)          # Shortcut for gte(:x, l) & lte(:x, h), for all l and h
Predicate.in(:x, 1..10)              # Shortcut for gte(:x, 1) & lte(:x, 10)
Predicate.in(:x, 1...10)             # Shortcut for gte(:x, 1) & lt(:x, 10)
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

### String operators

```ruby
Predicate.match(:x, /abc/)           # depends on usage, typically ruby's ===
```

### Native expressions

Ruby `Proc` can be used to capture complex predicates. Resulting predicates
cannot be translated to, e.g. SQL, and typically prevent optimizations and
manipulations:

```ruby
Predicate.native(->(t){
  Foo::Bar.call_to_ruby_code?(t)
})
```

## Available operators

The following operators are available on predicates.

### Evaluate

`Predicate#evaluate` takes a Hash mapping each free variable of the predicate
to a value, and returns the Boolean evaluation of the expression.

```ruby
# Let's build a simple predicate for 'x = 2 and not(y <= 3)'
p = Predicate.eq(:x, 2) & !Predicate.lte(:y, 3)

p.evaluate(x: 2, y: 6)
# => true
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
p.evaluate(x: 10)
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
p.qualify(x: :t, y: :s)       # t.x = 2 & s.y = 4
```

### And split

`Predicate#and_split` split a predicate `p` as two predicates `p1` and `p2`
so that `p <=> p1 & p2` and `p2` makes no reference to any variable of the
given list.

```ruby
p = Predicate.eq(x: 2, y: 4)  # x = 2 & y = 4
p1, p2 = p.and_split([:x])    # p1 is x = 2 ; p2 is y = 4 
```

Observe that `and_split` is always possible, but may degenerate to an
uninteresting `p2`, typically when disjunctions are used.
For instance,

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
# => {x: Predicate.eq(:x, 2), y: Predicate.eq(:y, 4)}
```

## Public API

This library follows semantics versioning 2.0. Its public API is:

* Class methods of the `Predicate` class, such as those covered in the
  "Building expressions" section above (that is, the `Predicate::Factory`
  module).

* Instance methods of the `Predicate` class, such as those covered in the
  "Available operators" section above.

* Instance and class methods contributed by plugins (e.g. `predicate/sequel`).

* Exception classes: `Predicate::NotSupportedError`,
  `Predicate::UnboundError`.

The AST representation of predicate expressions is NOT part of the public API.
We bump the minor version of the library when it changes, though.

Everything else is condidered private and may change any time (i.e. on patch
releases).

## Contributing

Please use github issues and pull requests, and favor the latter if possible.

## Licence

This software is distributed by Enspirit SRL under a MIT Licence. Please
contact Bernard Lambeau (blambeau@gmail.com) with any question.
