$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "rspec"
require 'predicate'

module Helpers

end

RSpec.configure do |c|
  c.include Helpers
  c.extend  Helpers
end
