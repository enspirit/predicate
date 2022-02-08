class Predicate
  module Factory
    def pg_array_literal(value, type = :varchar)
      _factor_predicate([
        :pg_array_literal,
        value,
        type
      ], Postgres::PgArray::Literal)
    end

    def pg_array_overlaps(left, right, type = :varchar)
      _factor_predicate([
        :pg_array_overlaps,
        sexpr(left),
        sexpr(right),
        type
      ], Postgres::PgArray::Overlaps)
    end

    def pg_array_empty(operand, type = :varchar)
      _factor_predicate([
        :pg_empty,
        sexpr(operand),
        type
      ], Postgres::PgArray::Empty)
    end
  end
end
