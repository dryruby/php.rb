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
        case method
          when :new
            if arguments.empty?
              "new #{receiver}"
            else
              "new #{receiver}(#{arguments.join(', ')})"
            end
          when :[]
            raise "expected a PHP::Literal, got #{arguments.first.inspect}" unless arguments.first.is_a?(Literal)
            case arguments.first.value
              when Symbol
                "#{receiver}->#{arguments.first}"
              else
                "#{receiver}[#{arguments.join(', ')}]"
            end
          else
            "#{receiver}->#{method}(#{arguments.join(', ')})"
        end
      end
    end
  end
end
