module PHP
  ##
  # @see http://php.net/manual/en/langref.php
  class Program < Node
    ##
    # @param  [Array<Statement>] statements
    def initialize(*statements)
      @children = statements
    end

    ##
    # Returns the statements that constitute this program.
    #
    # @return [Array<Statement>]
    def statements
      @children
    end

    ##
    # Appends a new statement to this program.
    #
    # @param  [Statement] statement
    # @return [Program]
    def <<(statement)
      super
    end

    ##
    # Returns the PHP representation of this program.
    #
    # @return [String]
    def to_php
      "<?php\n" << statements.map(&:to_php).join("\n") << (children? ? ";\n" : '')
    end
  end
end
