module PHP
  ##
  # @see http://php.net/manual/en/language.constants.php
  class Identifier < Expression
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
        when Symbol then name
        else
          raise ArgumentError.new("invalid PHP identifier name: #{name.inspect}") unless self.class.valid_name?(name)
          name.to_s.to_sym
      end
    end

    ##
    # Compares this identifier to `other` for sorting purposes.
    #
    # @return [Integer] -1, 0, 1
    def <=>(other)
      to_s <=> other.to_s
    end

    ##
    # Returns the PHP representation of this identifier.
    #
    # @return [String]
    def to_php
      name.to_s
    end

    ##
    # Returns the symbolic representation of this identifier.
    #
    # @return [Symbol]
    def to_sym
      name
    end
  end
end
