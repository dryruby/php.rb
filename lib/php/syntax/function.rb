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
    # Returns the PHP representation of this function.
    #
    # @return [String]
    def to_php
      "function #{name}() {}" # TODO
    end
  end
end
