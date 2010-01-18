module PHP
  ##
  class Identifier < Expression
    attr_accessor :name

    ##
    # @param  [Symbol, #to_s] name
    def initialize(name)
      @name = name.is_a?(Symbol) ? name : name.to_s.to_sym
    end
  end
end
