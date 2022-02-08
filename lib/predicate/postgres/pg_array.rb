class Predicate
  module Postgres
    module PgArray

      def to_pg_array(arg, type = :varchar)
        if arg.is_a?(Sequel::Postgres::PGArray)
          arg
        elsif arg.is_a?(Sequel::SQL::Wrapper)
          ::Sequel.pg_array(arg.value, type)
        elsif arg.is_a?(Array)
          ::Sequel.pg_array(arg, type)
        elsif arg.respond_to?(:pg_array)
          arg.pg_array
        else
          raise NotSupportedError, "Unexpected pg_array arg `#{arg}`::`#{arg.class}`"
        end
      end
      module_function :to_pg_array

    end # module PgArray
  end # module Postgres
end # class Predicate
require_relative 'pg_array/empty'
require_relative 'pg_array/overlaps'
require_relative 'pg_array/literal'
