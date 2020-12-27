### Interval operators

```ruby
Predicate.overlap([:x,:y], [1,10])
Predicate.touches([:x,:y], [1,10])
```

### Abstract operators

```ruby
Predicate.empty(:x)
Predicate.not_empty(:x)

Predicate.size(:x, 1..)
Predicate.size(:x, 1..10)
Predicate.size(:x, 1...10)

Predicate.cover(:x, [1, 2])
Predicate.cover(:x, 1..10)
Predicate.cover(:x, {foo: "bar"})
```
