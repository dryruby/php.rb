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

    ##
    class If < Statement
      attr_accessor :condition
      attr_accessor :then_branch
      attr_accessor :else_branch

      ##
      # @param [Expression] condition
      # @param [Expression] then_branch
      # @param [Expression] else_branch
      def initialize(condition, then_branch, else_branch = nil)
        @condition   = condition
        @then_branch = then_branch
        @else_branch = else_branch
      end

      ##
      # Returns `true` if this statement has an `else` branch.
      #
      # @return [Boolean]
      def else_branch?
        !@else_branch.nil?
      end

      ##
      # Returns the PHP representation of this if/then/else statement.
      #
      # @return [String]
      def to_php
        if else_branch?
          "if (#{condition}) { #{then_branch} } else { #{else_branch} }"
        else
          "if (#{condition}) { #{then_branch} }"
        end
      end
    end
  end
end
