module PHP
  ##
  # @see http://php.net/manual/en/language.variables.basics.php
  class Variable < Identifier
    ##
    # @return [Symbol]
    attr_accessor :name

    ##
    # @param  [Symbol, #to_s]          name
    # @param  [Hash{Symbol => Object}] options
    # @option options [Boolean] :global (false)
    def initialize(name, options = {})
      @name = case name
        when Variable
          name.to_php
        else
          raise ArgumentError.new("invalid PHP variable name: #{name.inspect}") unless self.class.valid_name?(name)
          name.to_s.to_sym
      end
      @options = options
    end

    ##
    # Returns `true` if this is a global variable.
    #
    # @return [Boolean]
    def global?
      @options[:global] == true
    end

    ##
    # Returns `true` if this is a local variable.
    #
    # @return [Boolean]
    def local?
      !global?
    end

    ##
    # Returns the PHP representation of this variable.
    #
    # @return [String]
    def to_php
      global? ? "$GLOBALS['#{name}']" : "$#{name}"
    end
  end
end
