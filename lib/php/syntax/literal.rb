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
        else value.to_s
      end
    end
  end
end
