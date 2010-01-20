module PHP
  ##
  # @see http://php.net/manual/en/language.control-structures.php
  class Loop < Expression
    ##
    # @see http://php.net/manual/en/control-structures.while.php
    class While < Loop
      ##
      # @return [Expression]
      attr_accessor :condition

      ##
      # @param  [Expression]   condition
      # @param  [Array<Block>] body
      def initialize(condition, *body)
        @condition = condition
        @children  = body.map { |exp| Block.for(exp) }
      end

      ##
      # Returns the PHP representation of this `while` loop.
      #
      # @return [String]
      def to_php
        body = children.map(&:to_php).join('; ')
        "while (#{condition}) { #{body} }" # FIXME
      end
    end

    ##
    # @see http://php.net/manual/en/control-structures.foreach.php
    class ForEach < Loop
      ##
      # @return [Expression]
      attr_accessor :iterable

      ##
      # @return [Expression]
      attr_accessor :iterator

      ##
      # @param  [Expression]   iterable
      # @param  [Expression]   iterator
      # @param  [Array<Block>] body
      def initialize(iterable, iterator, *body)
        @iterable = iterable
        @iterator = iterator
        @children = body.map { |exp| Block.for(exp) }
      end

      ##
      # Returns the PHP representation of this `foreach` loop.
      #
      # @return [String]
      def to_php
        body = children.map(&:to_php).join('; ')
        if iterator.children?
          "foreach (#{iterable} as #{iterator.children[0]} => #{iterator.children[1]}) { #{body} }" # FIXME
        else
          "foreach (#{iterable} as #{iterator}) { #{body} }" # FIXME
        end
      end
    end
  end
end
