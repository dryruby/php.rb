module PHP
  ##
  # @see http://php.net/manual/en/language.functions.php
  class Function < Expression
    ##
    # @param  [Symbol, #to_s] name
    # @param  [Array<Symbol>] parameters
    # @param  [Array<Block>]  body
    def initialize(name = nil, parameters = [], *body, &block)
      @name       = Identifier.new(name).to_sym rescue nil
      @parameters = parameters

      if block_given?
        # TODO
      else
        @children = body.compact.map { |exp| Block.for(exp) }
      end
    end

    ##
    # @return [Symbol]
    attr_accessor :name

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
      name.nil?
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
      @parameters || []
    end

    ##
    # Returns the PHP representation of this function.
    #
    # @return [String]
    def to_php
      body = children? ? ('{ ' << children.map(&:to_php).join('; ') << ' }') : '{}'
      if anonymous?
        "function(#{parameters.join(', ')}) " << body # FIXME
      else
        "function #{name}(#{parameters.join(', ')}) " << body # FIXME
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
