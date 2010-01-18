module PHP
  ##
  # @see http://php.net/manual/en/language.expressions.php
  class Statement < Expression
    ##
    # Returns the PHP representation of this statement.
    #
    # @return [String]
    def to_php
      "#{super};"
    end
  end
end
