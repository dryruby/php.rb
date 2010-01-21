module PHP
  ##
  # @see http://php.net/manual/en/language.types.php
  class Literal < Expression
    attr_accessor :value

    ##
    # @param  [Object] value
    def initialize(value)
      @value = value
    end

    ##
    # Compares this literal to `other` for sorting purposes.
    #
    # @return [Integer] -1, 0, 1
    def <=>(other)
      value <=> other.value
    end

    ##
    # Returns the PHP representation of this literal.
    #
    # @return [String]
    def to_php
      case value
        when NilClass   then 'NULL'
        when FalseClass then 'FALSE'
        when TrueClass  then 'TRUE'
        when Integer    then value.to_s
        when Float      then value.to_s
        when String     then value.inspect # FIXME
        when Regexp     then "'#{value.inspect}'"
        when Range
          if value.exclude_end?
            "range(#{value.first}, #{value.last - 1})" # FIXME
          else
            "range(#{value.first}, #{value.last})"
          end
        when ::Array
          "array(#{value.join(', ')})"
        when ::Hash
          pairs = value.to_a.map { |k, v| "#{k} => #{v}" }
          "array(#{pairs.join(', ')})"
        else value.to_s
      end
    end

    ##
    # @see http://php.net/manual/en/language.types.array.php
    class Array < Literal
      ##
      # @param  [Array<Expression>] elements
      def initialize(*elements)
        @children = elements
      end

      ##
      # Returns the PHP representation of this array literal.
      #
      # @return [String]
      def to_php
        "array(#{children.join(', ')})"
      end
    end

    ##
    # @example Creating an unordered associative array from a Hash
    #   PHP::Literal::Hash.new(:a => 1, :b => 2, :c => 3).to_s
    #   #=> "array(c => 3, a => 1, b => 2)"
    #
    # @example Creating an ordered associative array from Array pairs
    #   PHP::Literal::Hash.new([:a, 1], [:b, 2], [:c, 3]).to_s
    #   #=> "array(a => 1, b => 2, c => 3)"
    #
    # @see http://php.net/manual/en/language.types.array.php
    class Hash < Literal
      ##
      # @param  [Hash{Expression => Expression}, Array<Array(Expression, Expression)>] pairs
      def initialize(*pairs)
        if pairs.size == 1 && pairs.first.is_a?(::Hash)
          @children = pairs.first.to_a
        else
          @children = pairs
        end
      end

      ##
      # Returns the PHP representation of this associative array literal.
      #
      # @return [String]
      def to_php
        pairs = children.map { |k, v| "#{k} => #{v}" }
        "array(#{pairs.join(', ')})"
      end
    end
  end
end
