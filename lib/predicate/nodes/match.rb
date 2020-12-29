class Predicate
  module Match
    include BinaryFunc

    DEFAULT_OPTIONS = {
      case_sensitive: true
    }

    def options
      @options ||= DEFAULT_OPTIONS.merge(self[3] || {})
    end

    def case_sentitive?
      options[:case_sensitive]
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
