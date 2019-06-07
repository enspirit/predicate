class Predicate
  class ToSequel < Sexpr::Processor

    class Error < StandardError; end

    module Methods
      def on_identifier(sexpr)
        ::Sequel.identifier(sexpr.last)
      end

      def on_qualified_identifier(sexpr)
        ::Sequel.identifier(sexpr.name).qualify(sexpr.qualifier)
      end

      def on_literal(sexpr)
        sexpr.last.nil? ? nil : ::Sequel.expr(sexpr.last)
      end

      ###

      def on_tautology(sexpr)
        ::Sequel::SQL::BooleanConstant.new(true)
      end

      def on_contradiction(sexpr)
        ::Sequel::SQL::BooleanConstant.new(false)
      end

      def on_eq(sexpr)
        left, right = apply(sexpr.left), apply(sexpr.right)
        ::Sequel.expr(left => right)
      end

      def on_neq(sexpr)
        left, right = apply(sexpr.left), apply(sexpr.right)
        ~::Sequel.expr(left => right)
      end

      def on_dyadic_comp(sexpr)
        left, right = apply(sexpr.left), apply(sexpr.right)
        left.send(sexpr.operator_symbol, right)
      end
      alias :on_lt  :on_dyadic_comp
      alias :on_lte :on_dyadic_comp
      alias :on_gt  :on_dyadic_comp
      alias :on_gte :on_dyadic_comp

      def on_in(sexpr)
        left, right = apply(sexpr.identifier), sexpr.right
        if right.literal?
          values = Array(right.value).uniq
          if values.include?(nil)
            nonnil = values.compact
            if nonnil.empty?
              ::Sequel.expr(left => nil)
            elsif nonnil.size == 1
              ::Sequel.expr(left => nil) | ::Sequel.expr(left => nonnil.first)
            else
              ::Sequel.expr(left => nil) | ::Sequel.expr(left => nonnil)
            end
          else
            ::Sequel.expr(left => right.value)
          end
        elsif right.opaque?
          ::Sequel.expr(left => apply(right))
        else
          raise Error, "Unable to compile `#{right}` to sequel"
        end
      end

      def on_not(sexpr)
        ~apply(sexpr.last)
      end

      def on_and(sexpr)
        body = sexpr.sexpr_body
        body[1..-1].inject(apply(body.first)){|f,t| f & apply(t) }
      end

      def on_or(sexpr)
        body = sexpr.sexpr_body
        body[1..-1].inject(apply(body.first)){|f,t| f | apply(t) }
      end

      def on_match(sexpr)
        left, right = sexpr.left, sexpr.right
        left  = [ left.first,  "%#{left.last}%"  ] if left.first  == :literal && !left.last.is_a?(Regexp)
        right = [ right.first, "%#{right.last}%" ] if right.first == :literal && !right.last.is_a?(Regexp)
        left, right = apply(left), apply(right)
        if sexpr.case_sentitive?
          left.like(right)
        else
          left.ilike(right)
        end
      end

      def on_opaque(sexpr)
        return [sexpr.last] if sexpr.last.respond_to?(:sql_literal)
        raise Error, "Unable to compile #{sexpr} to Sequel"
      end

      def on_unsupported(sexpr)
        raise NotSupportedError
      end
      alias :on_native :on_unsupported
      alias :on_intersect :on_unsupported
    end
    include Methods
  end # class ToSequel
end # class Predicate
