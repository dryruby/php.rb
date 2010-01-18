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
