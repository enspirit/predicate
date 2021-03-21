require 'minitest'
class Predicate
  class Asserter
    include Minitest::Assertions

    def initialize
      @assertions = 0
    end
    attr_accessor :assertions

  end # class Asserter
end # class Predicate