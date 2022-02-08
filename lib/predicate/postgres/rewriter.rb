class Predicate
  module Postgres
    class Rewriter < Sexpr::Rewriter
      grammar Grammar

      class ToLiteral < Sexpr::Rewriter
        grammar Grammar

        def on_literal(sexpr)
          if sexpr.last.is_a?(Array)
            [ :pg_array_literal, sexpr.last, :varchar ]
          else
            sexpr
          end
        end

        alias :on_missing :copy_and_apply
      end

      def on_intersect(sexpr)
        rewriter = ToLiteral.new
        rewritten = sexpr[1..-1]
          .map{|expr| rewriter.call(expr) }
          .unshift(:pg_array_overlaps)
        rewritten.extend(PgArray::Overlaps)
      end

      def on_empty(sexpr)
        rewritten = sexpr[1..-1]
          .map{|expr| apply(expr) }
          .unshift(:pg_array_empty)
          .push(:varchar)
        rewritten.extend(PgArray::Empty)
      end

      alias :on_missing :copy_and_apply
    end
  end

  module Expr
    def to_postgres(*args)
      Postgres::Rewriter.new(*args).call(self)
    end
  end

  def to_postgres(*args)
    Predicate.new(expr.to_postgres(*args))
  end
end
