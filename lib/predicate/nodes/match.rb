class Predicate
  module Match
    include Expr

    DEFAULT_OPTIONS = {
      case_sensitive: true
    }

    def priority
      80
    end

    def left
      self[1]
    end

    def right
      self[2]
    end

    def options
      @options ||= DEFAULT_OPTIONS.merge(self[3] || {})
    end

    def case_sentitive?
      options[:case_sensitive]
    end

    def free_variables
      @free_variables ||= left.free_variables | right.free_variables
    end

    def dyadic_priority
      800
    end

    def evaluate(tuple)
      l = left.evaluate(tuple)
      r = right.evaluate(tuple)
      if l.nil? or r.nil?
        nil
      elsif l.is_a?(Regexp)
        l =~ r.to_s
      elsif r.is_a?(Regexp)
        r =~ l.to_s
      elsif options[:case_sensitive]
        l.to_s.include?(r.to_s)
      else
        l.to_s.downcase.include?(r.to_s.downcase)
      end
    end

  end
end
