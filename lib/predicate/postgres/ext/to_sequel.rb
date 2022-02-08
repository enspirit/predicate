class Predicate
  module Postgres
    module ToSequel
      def on_pg_array_literal(sexpr)
        PgArray.to_pg_array(sexpr[1], sexpr[2])
      end

      def on_pg_array_overlaps(sexpr)
        type = sexpr.last
        l = PgArray.to_pg_array(apply(sexpr.left), type)
        r = PgArray.to_pg_array(apply(sexpr.right), type)
        l.overlaps(r)
      end

      def on_pg_array_empty(sexpr)
        left = PgArray.to_pg_array(apply(sexpr.operand))
        right = PgArray.to_pg_array([], sexpr.last)
        ::Sequel.expr(left => right)
      end
    end
  end
end

class Predicate::ToSequel
  include Predicate::Postgres::ToSequel
end
