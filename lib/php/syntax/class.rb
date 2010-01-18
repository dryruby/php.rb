module PHP
  ##
  # @see http://php.net/manual/en/language.oop5.php
  class Class < Interface
    ##
    # @return [Symbol]
    attr_accessor :name

    ##
    # @return [Array<Node>]
    attr_accessor :methods

    ##
    # @param  [Symbol, #to_s]         name
    # @param  [Hash{Symbol => Object} options
    def initialize(name, options = {})
      @name, @options = Identifier.new(name).to_sym, options
    end

    ##
    # Returns `true` if this class has a defined superclass.
    #
    # @return [Boolean]
    def extends?
      !@options[:extends].nil?
    end

    ##
    # Returns the name of the superclass, if any, for this class.
    #
    # @return [Symbol]
    def extends
      @options[:extends] rescue nil
    end

    alias_method :superclass, :extends
    alias_method :parent,     :extends

    ##
    # Returns the PHP representation of this class.
    #
    # @return [String]
    def to_php
      if extends?
        "class #{name} extends #{extends} {}" # TODO
      else
        "class #{name} {}" # TODO
      end
    end
  end
end
