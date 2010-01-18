module PHP
  ##
  # @see http://php.net/manual/en/language.oop5.php
  class Class < Statement
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
    # Returns the PHP representation of this class.
    #
    # @return [String]
    def to_php
      "class #{name} {}" # TODO
    end
  end
end
