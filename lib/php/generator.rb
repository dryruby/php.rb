require 'sexp_processor'
require 'parse_tree'
require 'parse_tree_extensions'
require 'ruby_parser'

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
        #input = ParseTree.translate(input)
        input = RubyParser.new.process(input).to_a
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
      spec, args, body = exp
      if args.nil?
        Function.new(nil)
      else
        args = process(args)
        args = args.is_a?(Variable) ? [args] : args.to_a
        Function.new(nil, :parameters => args)
      end
    end

    ##
    # Processes `[:lasgn, symbol]` expressions.
    #
    # @example
    #   process([:lasgn, :x])
    #
    # @param  [Array(Symbol)] exp
    # @return [Variable]
    def process_lasgn(exp)
      Variable.new(exp.shift)
    end

    ##
    # Processes `[:dasgn_curr, symbol]` expressions.
    #
    # @example
    #   process([:dasgn_curr, :x])
    #
    # @param  [Array(Symbol)] exp
    # @return [Variable]
    def process_dasgn_curr(exp)
      Variable.new(exp.shift)
    end

    ##
    # Processes `[:masgn, ...]` expressions.
    #
    # @example
    #   process([:masgn, [:array, [:dasgn_curr, :x], [:dasgn_curr, :y]], nil, nil]) # ParseTree only
    #   process([:masgn, [:array, [:lasgn, :x], [:lasgn, :y]]])
    #
    # @param  [Array(Symbol)] exp
    # @return [Node]
    def process_masgn(exp)
      exp = exp.first
      exp.shift # removes the initial :array element
      Node.new(*exp.map { |asgn| process(asgn) }) # FIXME
    end

    ##
    # Processes `[:defn, symbol, ...]` expressions.
    #
    # @example Zero-arity functions
    #   process([:defn, :foo, [:scope, [:block, [:args], [:nil]]]]) # ParseTree only
    #   process([:defn, :foo, [:args], [:scope, [:block, [:nil]]]])
    #
    # @example One-arity functions
    #   process([:defn, :foo, [:scope, [:block, [:args, :x], [:nil]]]]) # ParseTree only
    #   process([:defn, :foo, [:args, :x], [:scope, [:block, [:nil]]]])
    #
    # @param  [Array(Symbol, Array)] exp
    # @return [Function]
    def process_defn(exp)
      name = exp.shift
      args = (exp.size == 2 ? process(exp.shift) : []).to_a # ParseTree workaround
      body = process(exp.shift)
      Function.new(name, :parameters => args) # TODO
    end

    ##
    # Processes `[:args, ...]` expressions.
    #
    # @example
    #   process([:args])
    #   process([:args, :x])
    #   process([:args, :x, :y])
    #
    # @param  [Array] exp
    # @return [Node]
    def process_args(exp)
      Node.new(*exp.map { |arg| Variable.new(arg) })
    end

    ##
    # Processes `[:scope, [...]]` expressions.
    #
    # @example
    #   process([:scope, [:block, [:args], [:nil]]]) # ParseTree only
    #   process([:scope, [:block, [:nil]]])
    #
    # @param  [Array(Array)] exp
    # @return [Node]
    def process_scope(exp)
      process(exp.first)
    end

    ##
    # Processes `[:block, ...]` expressions.
    #
    # @example
    #   process([:block, [:args], [:nil]]) # ParseTree only
    #   process([:block, [:nil]])
    #
    # @param  [Array<Array>] exp
    # @return [Node]
    def process_block(exp)
      process(exp.last)
    end
  end
end
