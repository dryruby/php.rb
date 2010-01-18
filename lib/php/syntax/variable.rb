module PHP
  ##
  # @see http://php.net/manual/en/language.variables.basics.php
  class Variable < Identifier
    ##
    # @return [Symbol]
    attr_accessor :name

    ##
    # @param  [Symbol, #to_s] name
    def initialize(name)
      @name = case name
        when Variable
          name.to_php
        else
          raise ArgumentError.new("invalid PHP variable name: #{name.inspect}") unless self.class.valid_name?(name)
          name.to_s.to_sym
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
