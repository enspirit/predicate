$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "rspec"
require 'predicate'
require_relative 'shared/a_predicate'

module Helpers

end

RSpec.configure do |c|
  c.include Helpers
  c.extend  Helpers
end
