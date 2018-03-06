# 1.1.2 / TBD

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
