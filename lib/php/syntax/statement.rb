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
    class Return < Statement
      ##
      # @return [Expression]
      attr_accessor :value

      ##
      # @param  [Expression] value
      def initialize(value)
        @value = value
      end

      ##
      # Returns `true` if this statement has a value.
      #
      # @return [Boolean]
      def value?
        !value.nil?
      end

      ##
      # Returns the PHP representation of this return statement.
      #
      # @return [String]
      def to_php
        if value?
          "return #{value}"
        else
          "return"
        end
      end
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
        @then_branch = Block.for(then_branch)
        @else_branch = Block.for(else_branch)
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
