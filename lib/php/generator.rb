require 'sexp_processor'
require 'parse_tree'
require 'parse_tree_extensions'

module PHP
  ##
  class Generator < SexpProcessor
    ##
    # @overload process(input)
    #   @param  [String] input
    #
    # @overload process(&block)
    #   @yield
    #
    # @return [Node]
    def self.process(input = nil, &block)
      if block_given?
        input = block.to_sexp
      else
        input = ParseTree.translate(input)
      end
      self.new.process(input)
    end

    ##
    def initialize
      super
      self.strict          = true
      self.auto_shift_type = true
      self.require_empty   = false
      self.expected        = Node
    end

    ##
    # Processes `[:nil]` expressions.
    #
    # @param  [Array<Object>] exp
    # @return [Literal]
    def process_nil(exp)
      Literal.new(nil)
    end

    ##
    # Processes `[:false]` expressions.
    #
    # @param  [Array<Object>] exp
    # @return [Literal]
    def process_false(exp)
      Literal.new(false)
    end

    ##
    # Processes `[:true]` expressions.
    #
    # @param  [Array<Object>] exp
    # @return [Literal]
    def process_true(exp)
      Literal.new(true)
    end

    ##
    # Processes `[:lit, value]` expressions.
    #
    # @param  [Array<Object>] exp
    # @return [Literal]
    def process_lit(exp)
      Literal.new(exp.shift)
    end

    ##
    # Processes `[:str, value]` expressions.
    #
    # @param  [Array<Object>] exp
    # @return [Literal]
    def process_str(exp)
      Literal.new(exp.shift)
    end
  end
end
