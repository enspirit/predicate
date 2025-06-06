# 2.9.0 - 2025-04-03

* Add Predicate#to_hashes that returns a pair of positive and
  negative hashes. Generalization of to_hash where neq are used.

# 2.8.0 - 2023-06-09

* BREAKING: removed support for ruby < 2.7 and upgraded sexpr
  to 1.1.x

* Added Predicate#assert!, with the help of minitest.

  Implementation is fuly functional, yet error messages will
  be improved in the future by a better usage of minitest itself.

# 2.7.1 - 2022-04-21

* Add shadow support for Exists tree nodes, that are used by
  Bmg for some `restrict -> WHERE` translations.

# 2.7.0 - 2022-02-10

* Add (experimental) support for translation of `empty` and
  `intersect` on arrays to usage of PostgreSQL's `pg_array`
  operators (`overlaps` in particular).

# 2.6.0 - 2021-12-11

* Upgraded `sexpr` to 1.0

* Add `Predicate.h` that takes a Hash mapping variable names to
  values. This generates a AND-predicate with one term for each
  pair. Keys must map to variables (hence, typically Symbol).
  An Array value yields an IN-predicate. A Regexp value yields
  a MATCH. Other literals yield EQ predicates.

  Examples:

    Predicate.h(:x => 2, ...)         # eq(:x, 2) & ...
    Predicate.h(:x => [2,3], ...)     # in(:x, [2,2]) & ...
    Predicate.h(:x => /a-z/, ...)     # match(:x, /a-z/) & ...

# 2.5.0 - 2020-12-30

* Add `Predicate.dsl` for building complex expressions without having
  to prefix factory methods with `Predicate.` all the time.

* Add `Predicate.currying` for building complex expressions on a
  single variable (say :x) without having to repeat :x as first
  argument all the time.

* Add `Predicate.var` and `Predicate.vars` for working with abstract
  variables over complex data structures.

* Add `Predicate.in(:x, Range)` as a shortcut over comparison
  operators.

* Add `Predicate.is_null`, `Predicate.empty`, `.has_size`, `.min_size`,
  `.max_size`.

* Add negated and camelCase predicate forms, available only when using
  the `dsl` and `currying` variant of it.

* Enhance `Predicate.intersect` to work fine between two variables.
  WARN: This changes the internal AST representation of set
  operators to have a real node at right.

* Add `Predicate.subset` & `Predicate.superset`, similarly.

* Enhanced README, specified the public API, add jeny code blocks to
  help contributors providing new predicates.

# 2.4.0 / 2020-07-23

* Add Predicate#to_hash that allows getting back a Hash object
  representing the same predicate as of `Predicate.coerce` semantics.
  The method raises an ArgumentError if the predicate cannot be
  simplified so as to preserve the semantics.

# 2.3.3 / 2020-07-08

* Add Predicate#unqualify that transforms all qualified identifiers to
  normal identifiers. The resulting predicate might not be semantically
  equivalent.

# 2.3.2 / 2020-07-08

* Fix Predicate#& when using qualified identifier. The qualifier was not
  correctly taken into account, yielding conjunctions wrongly loosing
  terms.

# 2.3.1 / 2020-04-29

* Fix #eq against #in having a placeholder. Yields a undefined method
  `include?`.

# 2.3.0 / 2020-04-20

* Add an experimental support for literal placeholders. The aim is to let
  build complex expressions with unknown literals, to be bound later using
  #bind. The latter returns a copy of the predicate, with placeholders
  replaced by the values provided:

      pl = Predicate.placeholder
      p = Predicate.eq(:x, pl)
      p2 = p.bind(x: 12)
      p2.evaluate(x: 12)          # => true

* Fix Predicate.intersect having wrong #constants_variables logic.

# 2.2.1 / 2020-01-21

* Fix `in(:x, [2, 3]) & eq(:x, 1)` begin wrongly optimized as `eq(:x, 1)`
  while it must yield a contradiction.

# 2.2.0 / 2019-06-07

* Fix SQL compilation of `Predicate#in` where the list of values
  contains nil, including edge cases (e.g. where only nil is present).
  In such cases a `x IS NULL OR (x IN (...))` is generated.

* Add `Predicate#call` alias to `Predicate#evaluate` in order to let
  client write simpler expressions.

# 2.1

* Introduction of an `opaque` node kind to help with pseudo-literals
  used in IN expressions. IN expressions now accept any right term,
  instead of an array of values.

# 2.0 - 2018-05-28

* Add `Predicate#match` to match attributes against strings and
  regular expressions.

* BREAKING CHANGE: Predicate#to_ruby_code and Predicate#to_proc have
  been removed. Mostly because they are difficult to maintain, but
  also because they tend to be dangerous to use from a security point
  of view (allowing end user code injection).

# 1.3.4 / 2018-03-30

* `Predicate.in` now returns a contradiction when the set of values
  is known to be empty.

# 1.3.3 / 2018-03-16

* Add `Predicate#to_s` and `#inspect` with a more readable predicate
  representation.

# 1.3.2 / 2018-03-14

* Fix `#evaluate` on `Predicate.in`.

# 1.3.1 / 2018-03-13

* Fix `#evaluate` on `Predicate.intersect`.

# 1.3 / 2018-03-13

* Add various & optimizations, typically those yielding tautologies
  and contradictions.

* Add `Predicate#constants` that returns a Hash mapping identifiers
  to the known constant, if any. E.g. if `#constants` returns
  `{x: 2}`, it means the predicate is of the form `x = 2 AND ...`.

* Fix ruby code generation of `#intersect` to be robust when the
  tested attribute is nil in the tuple. Intersects returns false in
  such a case.

* Changed `Predicate#evaluate` to avoid relying on an unsafe ruby
  code generation.

# 1.2 / 2018-03-09

* Add `Predicate#intersect` that has same limitations than `#in`
  (only `identifier OP values` is supported) but an array/set
  intersection semantics.
  The generated ruby code relies on ruby's `&` semantics.
  The operator is not supported in Sequel compilation.

* Add `Predicate#attr_split` that helps splitting a predicate as a
  conjunction os sub predicates making references to a single attribute
  only.

* `Predicate#qualify` now accepts a global qualifier as a Symbol in
  addition to a Hash mapping each variable to a given qualifier.

* [Sequel] Fix a bug in SQL generation when qualified identifiers are
  used. `WHERE table AS field = ...` was generated instead of the
  correct `WHERE table.field = ...`

* [Sequel] Add support for `Predicate.in(:x, operand)` where operand
  is a Sequel compatible literal, that is, an object responding to
  `:sql_literal`.

# 1.1.3 / 2018-03-07

* Document `and_split` and review all actual implementations to make sure
  of their correctness. Let Native implement the specification without
  throwing a NotSupportedError.

# 1.1.2 / 2018-03-06

* Fix error raised by Sequel when trying to compile a Native predicate.
  Predicate::NotSupportedError must be raised, not NotImplementedError.

# 1.1.1 / 2018-03-03

* Removed unnecessary & unused 'path' dependency.

# 1.1.0 / 2018-03-03

* Adds `Predicate.from_hash(x: 12, y: ['foo', 'bar'])`, also supported
  by `Predicate.coerce(...)`, with `x = 12 and y in ('foo','bar')`
  semantics

* Adds `Predicate.to_sequel` that compiles predicates to Sequel
  expressions. Note that Sequel is not a dependency of Predicate and
  must be required by the user. `Predicate.to_sequel` is only available
  if `require 'predicate/sequel'` is done first.

# 1.0.0 / 2018-03-03

Predicate 1.0.0, extracted & refactored from alf-core.

This commit starts the Predicate gem. It is a pure extraction from
alf-core (https://github.com/alf-tool/alf-core), yet slightly
refactored as follows:

* Tuples are supposed to be represented by Hashes, and attributes
  accessed through `Hash#[]`. This is a major change in comparison
  to Alf, since code generation yields `t[:x]` while `t.x` is used
  in Alf.
* AttrList are replaced by pure ruby Arrays.
* Renaming are replaces by pure ruby Hashes.
* `to_ruby_literal(x)` has been implemented as `x.inspect` instead
  of relying on the Myrrha gem.
