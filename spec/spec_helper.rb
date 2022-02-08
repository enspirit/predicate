$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rspec'
require 'sequel'
require 'sqlite3'
require 'pg'
require 'predicate'
require 'predicate/sequel'
require 'predicate/postgres'
require_relative 'shared/a_predicate'

Sequel.extension :pg_array, :pg_array_ops
module Helpers

  def create_items_database(db)
    db.drop_table? :items
    db.create_table :items do
      primary_key :id
      String :name
      String :address
      Float :price
    end
  end

end

RSpec.configure do |c|
  c.include Helpers
  c.extend  Helpers
end
