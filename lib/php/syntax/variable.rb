module PHP
  ##
  # @see http://php.net/manual/en/language.variables.basics.php
  class Variable < Expression
    SYNTAX = /^[a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*$/

    ##
    # Returns `true` if `name` is a valid PHP variable name.
    #
    # @param  [Symbol, #to_s] name
    # @return [Boolean]
    def self.valid_name?(name)
      !(name.to_s =~ SYNTAX).nil?
    end

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
          raise ArgumentError.new("invalid variable name: #{name.inspect}") unless self.class.valid_name?(name)
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
