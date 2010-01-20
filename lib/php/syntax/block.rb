module PHP
  ##
  # @see http://php.net/manual/en/language.basic-syntax.instruction-separation.php
  class Block < Expression
    ##
    # Returns the given `expression` wrapped into a `Block` node; unless it
    # already is a `Block`, in which case it is returned as-is.
    #
    # @param  [Expression] expression
    # @return [Block]
    def self.for(expression)
      case expression
        when nil   then nil
        when Block then expression
        else Block.new(expression)
      end
    end

    ##
    # Returns the PHP representation of this block.
    #
    # @return [String]
    def to_php
      children.map(&:to_php).join('; ') << ';' # FIXME
    end
  end
end
