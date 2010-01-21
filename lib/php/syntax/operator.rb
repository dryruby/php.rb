module PHP
  ##
  # @see http://php.net/manual/en/language.operators.php
  class Operator < Expression
    def self.for(operator)
      case operator
        when :-@    then Arithmetic::Negation
        when :+     then Arithmetic::Addition
        when :-     then Arithmetic::Subtraction
        when :*     then Arithmetic::Multiplication
        when :'/'   then Arithmetic::Division
        when :'%'   then Arithmetic::Modulus
        when :~     then Bitwise::Not
        when :&     then Bitwise::And
        when :|     then Bitwise::Or
        when :^     then Bitwise::Xor
        when :>>    then Bitwise::ShiftRight
        when :==    then Comparison::Equal
        when :===   then Comparison::Identical
        when :'!='  then Comparison::NotEqual
        when :'!==' then Comparison::NotIdentical
        when :<     then Comparison::LessThan
        when :>     then Comparison::MoreThan
        when :<=    then Comparison::LessOrEqual
        when :>=    then Comparison::MoreOrEqual
        when :'!'   then Logical::Not
        when :'&&'  then Logical::And
        when :'||'  then Logical::Or
        when :<<    then String::Concatenation
        when :=~    then Regex::Match
      end
    end

    ##
    # Returns the operator for this operation.
    #
    # @return Symbol
    # @abstract
    def operator
      raise NotImplementedError
    end

    alias_method :to_sym, :operator

    ##
    # Returns the operands for this operation.
    #
    # @return [Array<Expression>]
    # @abstract
    def operands
      raise NotImplementedError
    end

    ##
    # Returns an array representation of this operation.
    #
    # @return [Array<Object>]
    def to_a
      [operator, *operands]
    end

    alias_method :to_sxp, :to_a

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

      ##
      # Returns the operands for this operation.
      #
      # @return [Array(Expression)]
      def operands
        [operand]
      end

      ##
      # Returns the PHP representation of this operation.
      #
      # @return [String]
      def to_php
        "#{operator}#{operand}"
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

      ##
      # Returns the operands for this operation.
      #
      # @return [Array(Expression, Expression)]
      def operands
        [lhs, rhs]
      end

      ##
      # Returns the PHP representation of this operation.
      #
      # @return [String]
      def to_php
        "#{lhs} #{operator} #{rhs}"
      end
    end

    ##
    # @see http://php.net/manual/en/language.operators.comparison.php#language.operators.comparison.ternary
    class Ternary < Operator
      # TODO
    end

    ##
    # @see http://php.net/manual/en/language.operators.arithmetic.php
    module Arithmetic
      OPERATORS = [:+, :-, :*, :'/', :'%']

      ##
      class Negation < Unary
        def operator() :'-' end
      end

      ##
      class Addition < Binary
        def operator() :+ end
      end

      ##
      class Subtraction < Binary
        def operator() :- end
      end

      ##
      class Multiplication < Binary
        def operator() :* end
      end

      ##
      class Division < Binary
        def operator() :'/' end
      end

      ##
      class Modulus < Binary
        def operator() :% end
      end
    end

    ##
    # @see http://php.net/manual/en/language.operators.assignment.php
    class Assignment < Binary
      def operator() :'=' end
    end

    ##
    # @see http://php.net/manual/en/language.operators.bitwise.php
    module Bitwise
      OPERATORS = [:~, :&, :|, :^, :>>]

      ##
      class Not < Unary
        def operator() :~ end
      end

      ##
      class And < Binary
        def operator() :& end
      end

      ##
      class Or < Binary
        def operator() :| end
      end

      ##
      class Xor < Binary
        def operator() :^ end
      end

      ##
      class ShiftLeft < Binary
        def operator() :<< end
      end

      ##
      class ShiftRight < Binary
        def operator() :>> end
      end
    end

    ##
    # @see http://php.net/manual/en/language.operators.comparison.php
    module Comparison
      OPERATORS = [:==, :===, :'!=', :'!==', :<, :>, :<=, :>=]

      ##
      class Equal < Binary
        def operator() :== end
      end

      ##
      class Identical < Binary
        def operator() :=== end
      end

      ##
      class NotEqual < Binary
        def operator() :'!=' end
      end

      ##
      class NotIdentical < Binary
        def operator() :'!==' end
      end

      ##
      class LessThan < Binary
        def operator() :< end
      end

      ##
      class MoreThan < Binary
        def operator() :> end
      end

      ##
      class LessOrEqual < Binary
        def operator() :<= end
      end

      ##
      class MoreOrEqual < Binary
        def operator() :>= end
      end
    end

    ##
    # @see http://php.net/manual/en/language.operators.execution.php
    class Execution < Unary
      ##
      # Returns the PHP representation of this operation.
      #
      # @return [String]
      def to_php
        "`#{operand}`"
      end
    end

    ##
    # @see http://php.net/manual/en/language.operators.logical.php
    module Logical
      OPERATORS = [:'!', :'&&', :'||']

      ##
      class Not < Unary
        def operator() :'!' end
      end

      ##
      class And < Binary
        def operator() :'&&' end
      end

      ##
      class Or < Binary
        def operator() :'||' end
      end
    end

    ##
    # @see http://php.net/manual/en/language.operators.string.php
    module String
      OPERATORS = [:'.']

      ##
      class Concatenation < Binary
        def operator() :'.' end
      end
    end

    ##
    # @see http://php.net/manual/en/book.pcre.php
    module Regex
      OPERATORS = [:=~]

      ##
      # @see PHP::Generator#process_match3
      class Match < Binary
        def operator() :preg_match end

        def to_php
          "#{operator}(#{lhs}, #{rhs})"
        end
      end
    end
  end
end
