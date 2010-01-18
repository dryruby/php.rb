module PHP
  ##
  class Variable < Expression
    attr_accessor :name

    ##
    # @param  [Symbol, #to_s] name
    def initialize(name)
      @name = case name
        when Symbol then name
        else name.to_s.to_sym
      end
    end

    ##
    # Returns the PHP representation of this variable.
    #
    # @return [String]
    def to_php
      "$#{name}"
    end
  end
end
