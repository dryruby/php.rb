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
  end
end
