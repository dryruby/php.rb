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
        # The return value from #to_sexp will be in the format:
        # `s(:iter, s(:call, nil, :proc, s(:arglist)), nil, s(...))`
        input = block.to_sexp.last.to_a
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
    # @param  [Array()] exp
    # @return [Literal]
    def process_nil(exp)
      Literal.new(nil)
    end

    ##
    # Processes `[:false]` expressions.
    #
    # @param  [Array()] exp
    # @return [Literal]
    def process_false(exp)
      Literal.new(false)
    end

    ##
    # Processes `[:true]` expressions.
    #
    # @param  [Array()] exp
    # @return [Literal]
    def process_true(exp)
      Literal.new(true)
    end

    ##
    # Processes `[:lit, value]` expressions.
    #
    # @param  [Array(Object)] exp
    # @return [Literal]
    def process_lit(exp)
      Literal.new(exp.shift)
    end

    ##
    # Processes `[:str, value]` expressions.
    #
    # @param  [Array(String)] exp
    # @return [Literal]
    def process_str(exp)
      Literal.new(exp.shift)
    end

    ##
    # Processes `[:gvar, symbol]` expressions.
    #
    # @example
    #   process{$foo} == process([:gvar, :$foo])
    #
    # @param  [Array(Symbol)] exp
    # @return [Variable]
    def process_gvar(exp)
      Variable.new(exp.shift.to_s[1..-1], :global => true) # NOTE: removes the leading '$' character
    end

    ##
    # Processes `[:vcall, symbol]` expressions.
    #
    # @param  [Array(Symbol)] exp
    # @return [Variable]
    def process_vcall(exp) # FIXME
      if exp.size == 1
        Variable.new(exp.shift)
      else
        raise NotImplementedError
      end
    end

    ##
    # Processes `[:iter, ...]` expressions.
    #
    # @param  [Array<Object>] exp
    # @return [Variable]
    def process_iter(exp)
      Function.new(nil)
    end

  end
end
