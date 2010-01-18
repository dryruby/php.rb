module PHP
  ##
  # @see http://php.net/manual/en/language.operators.php
  class Operator < Expression
    ##
    class Unary < Operator
      ##
      # @return [Expression]
      attr_accessor :operand

      ##
      # @param  [Expression] operand
      def initialize(operand)
        @operand = operand
      end
    end

    ##
    class Binary < Operator
      ##
      # @return [Expression]
      attr_accessor :lhs

      ##
      # @return [Expression]
      attr_accessor :rhs

      ##
      # @param  [Expression] lhs
      # @param  [Expression] rhs
      def initialize(lhs, rhs)
        @lhs, @rhs = lhs, rhs
      end
    end

    ##
    # @see http://www.php.net/manual/en/language.operators.string.php
    module String
      ##
      class Concatenation < Binary
        ##
        # Returns the PHP representation of this operator.
        #
        # @return [String]
        def to_php
          "#{lhs} . #{rhs}"
        end
      end
    end

    ##
    # @see http://www.php.net/manual/en/language.operators.logical.php
    module Logical
      ##
      class Not < Unary
        ##
        # Returns the PHP representation of this operator.
        #
        # @return [String]
        def to_php
          "!#{operand}"
        end
      end

      ##
      class And < Binary
        ##
        # Returns the PHP representation of this operator.
        #
        # @return [String]
        def to_php
          "#{lhs} && #{rhs}"
        end
      end

      ##
      class Or < Binary
        ##
        # Returns the PHP representation of this operator.
        #
        # @return [String]
        def to_php
          "#{lhs} || #{rhs}"
        end
      end
    end
  end
end
