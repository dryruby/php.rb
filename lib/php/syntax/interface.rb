module PHP
  ##
  # @see http://php.net/manual/en/language.oop5.php
  class Interface < Statement
    ##
    # @return [Symbol]
    attr_accessor :name

    ##
    # @param  [Symbol, #to_s]         name
    # @param  [Hash{Symbol => Object} options
    def initialize(name, options = {})
      @name, @options = Identifier.new(name).to_sym, options
    end

    ##
    # Returns the PHP representation of this interface.
    #
    # @return [String]
    def to_php
      "interface #{name} {}" # TODO
    end
  end
end
