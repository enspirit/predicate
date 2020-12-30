class Predicate
  module Var
    include Expr

    def priority; 100; end

    def formaldef
      self[1]
    end

    def semantics
      self[2]
    end

    def free_variables
      @free_variables ||= [ [formaldef, semantics] ]
    end

    def dig_terms
      @dig_terms ||= case formaldef
      when String
        formaldef.split(".").map{|elm|
          elm =~ /^\d+$/ ? elm.to_i : elm.to_sym
        }
      when Array
        formaldef
      else
        raise ArgumentError, "Unrecognized variable def `#{formaldef}`"
      end
    end

    def evaluate(on)
      case semantics
      when :dig
        dig_terms.inject(on){|ctx,elm| ctx.dig(elm) }
      when :send
        dig_terms.inject(on){|ctx,elm| ctx.__send__(elm.to_sym) }
      when :public_send
        dig_terms.inject(on){|ctx,elm| ctx.public_send(elm.to_sym) }
      else
        raise ArgumentError, "Unrecognized variable semantics `#{semantics}`"
      end
    end

  end
end
