module PHP
  ##
  # @see http://php.net/manual/en/language.functions.php
  class Function < Expression
    ##
    # @return [Symbol]
    attr_accessor :name

    ##
    # @param  [Symbol, #to_s]         name
    # @param  [Hash{Symbol => Object} options
    def initialize(name = nil, options = {}, &block)
      @name    = Identifier.new(name).to_sym rescue nil
      @options = options

      if block_given?
        # TODO
      end
    end

    ##
    # Returns `true` if this is a named function.
    #
    # @return [Boolean]
    def named?
      !anonymous?
    end

    ##
    # Returns `true` if this is an anonymous function.
    #
    # @return [Boolean]
    def anonymous?
      @name.nil?
    end

    alias_method :unnamed?, :anonymous?

    ##
    # Returns the arity of this function.
    #
    # @return [Integer]
    def arity
      parameters.size
    end

    ##
    # Returns the parameters, if any, of this function.
    #
    # @return [Array<Symbol>]
    def parameters
      @options[:parameters] || []
    end

    ##
    # Returns the PHP representation of this function.
    #
    # @return [String]
    def to_php
      if anonymous?
        "function(#{parameters.join(', ')}) {}" # TODO
      else
        "function #{name}(#{parameters.join(', ')}) {}" # TODO
      end
    end

    ##
    # @see http://php.net/manual/en/language.functions.php
    class Call < Expression
      ##
      # @return [Symbol]
      attr_accessor :function

      ##
      # @return [Array<Expression>]
      attr_accessor :arguments

      ##
      # @param  [Symbol, #to_s]     function
      # @param  [Array<Expression>] arguments
      def initialize(function, *arguments)
        @function  = Identifier.new(function).to_sym
        @arguments = arguments
      end

      ##
      # Returns the PHP representation of this function call.
      #
      # @return [String]
      def to_php
        "#{function}(#{arguments.join(', ')})"
      end
    end
  end
end
