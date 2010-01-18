module PHP
  ##
  class Node
    ##
    # Returns the PHP representation of this AST node.
    #
    # @return [String]
    # @abstract
    def to_php
      raise NotImplementedError
    end

    alias_method :to_s, :to_php
  end
end
