module PHP
  ##
  # @see http://php.net/manual/en/language.constants.php
  class Identifier < Expression
    attr_accessor :name

    ##
    # @param  [Symbol, #to_s] name
    def initialize(name)
      @name = name.is_a?(Symbol) ? name : name.to_s.to_sym
    end

    ##
    # Returns the PHP representation of this identifier.
    #
    # @return [String]
    def to_php
      name.to_s
    end
  end
end
