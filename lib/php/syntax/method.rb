module PHP
  ##
  # @see http://www.php.net/manual/en/language.oop5.php
  class Method < Expression
    ##
    # @see http://www.php.net/manual/en/language.oop5.php
    class Call < Expression
      ##
      # @return [Expression]
      attr_accessor :receiver

      ##
      # @return [Symbol]
      attr_accessor :method

      ##
      # @return [Array<Expression>]
      attr_accessor :arguments

      ##
      # @param  [Expression]        receiver
      # @param  [Symbol, #to_s]     method
      # @param  [Array<Expression>] arguments
      def initialize(receiver, method, *arguments)
        @receiver  = receiver
        @method    = Identifier.new(method).to_sym
        @arguments = arguments
      end

      ##
      # Returns the PHP representation of this method call.
      #
      # @return [String]
      def to_php
        "#{receiver}->#{method}(#{arguments.join(', ')})"
      end
    end
  end
end
