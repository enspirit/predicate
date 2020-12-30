class Predicate
  module NadicBool
    include Expr

    def priority; 60; end

    def free_variables
      @free_variables ||= sexpr_body.inject([]){|list,term| 
        list | term.free_variables
      }
    end

  end
end
