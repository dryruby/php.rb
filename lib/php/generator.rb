require 'sexp_processor'
require 'parse_tree'
require 'parse_tree_extensions'
require 'ruby_parser'

module PHP
  ##
  class Generator < SexpProcessor
    ##
    # @overload process(input, options = {})
    #   @param  [String] input
    #   @param  [Hash{Symbol => Object}] options
    #
    # @overload process(options = {}, &block)
    #   @yield
    #   @param  [Hash{Symbol => Object}] options
    #
    # @return [Node]
    def self.process(input = nil, options = {}, &block)
      if block_given?
        # The return value from #to_sexp will be in the format:
        # `s(:iter, s(:call, nil, :proc, s(:arglist)), nil, s(...))`
        input = block.to_sexp.last.to_a
      else
        #input = ParseTree.translate(input)
        input = RubyParser.new.process(input).to_a
      end
      input.size > 0 ? self.new.process(input) : nil
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
    # Processes `[:dstr, prefix, ...]` expressions.
    #
    # @example
    #   process([:dstr, "<", [:evstr, [:call, nil, :url, [:arglist]]], [:str, ">"]])
    #
    # @param  [Array] exp
    # @return [Operator::String::Concatenation]
    def process_dstr(exp)
      prefix = exp.shift.to_s
      parts  = prefix.empty? ? [] : [Literal.new(prefix)]
      parts += exp.map { |part| process(part) }
      parts.reverse.inject(nil) do |prefix, part|
        prefix.nil? ? part : Operator::String::Concatenation.new(part, prefix)
      end
    end

    ##
    # Processes `[:evstr, operation]` expressions.
    #
    # @example
    #   process([:evstr, [:call, nil, :url, [:arglist]]])
    #
    # @param  [Array(Array)] exp
    # @return [Expression]
    def process_evstr(exp)
      process(exp.shift)
    end

    ##
    # Processes `[:array, ...]` expressions.
    #
    # @example
    #   process{[1, 2, 3]} == process([:array, [:lit, 1], [:lit, 2], [:lit, 3]])
    #
    # @param  [Array<Array>] exp
    # @return [Literal::Array]
    def process_array(exp)
      Literal::Array.new(*exp.map { |element| process(element) })
    end

    ##
    # Processes `[:hash, ...]` expressions.
    #
    # @example
    #   process{{:a => 1, :b => 2}} == process([:hash, [:lit, :a], [:lit, 1], [:lit, :b], [:lit, 2]])
    #
    # @param  [Array<Array>] exp
    # @return [Literal::Hash]
    def process_hash(exp)
      Literal::Hash.new(*exp.map { |element| process(element) }.enum_slice(2))
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
      Variable.new(exp.shift.to_s[1..-1]) # NOTE: removes the leading '$' character
    end

    ##
    # Processes `[:gasgn, symbol, value]` expressions.
    #
    # @example
    #   process{$foo = 123} == process([:gasgn, :$foo, [:lit, 123]])
    #
    # @param  [Array(Symbol, Array)] exp
    # @return [Operator::Assignment]
    def process_gasgn(exp)
      var = Variable.new(exp.shift.to_s[1..-1]) # NOTE: removes the leading '$' character
      val = process(exp.shift)
      val ? Operator::Assignment.new(var, val) : var
    end

    ##
    # Processes `[:lvar, symbol]` expressions.
    #
    # @example
    #   process([:lvar, :foo])
    #
    # @param  [Array(Symbol)] exp
    # @return [Variable]
    def process_lvar(exp)
      Variable.new(exp.shift)
    end

    ##
    # Processes `[:vcall, symbol]` expressions.
    #
    # @example
    #   process{foo} == process([:vcall, :foo]) # ParseTree only
    #
    # @param  [Array(Symbol)] exp
    # @return [Variable]
    def process_vcall(exp) # FIXME
      raise NotImplementedError.new(exp.inspect) # TODO
    end

    ##
    # Processes `[:call, ...]` expressions.
    #
    # @example
    #   process{foo}       == process([:call, nil, :foo, [:arglist]])
    #   process{add(1, 2)} == process([:call, nil, :add, [:arglist, [:lit, 1], [:lit, 2]]])
    #
    # @param  [Array] exp
    # @return [Node]
    def process_call(exp)
      receiver, method, arglist = exp
      case
        when receiver.nil?
          Function::Call.new(method, *process(arglist))
        when op = Operator.for(method)
          op.new(process(receiver), *process(arglist))
        else
          Method::Call.new(process(receiver), method, *process(arglist))
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
        Function.new(nil, args) # FIXME
      end
    end

    ##
    # Processes `[:lasgn, symbol, value]` expressions.
    #
    # @example
    #   process([:lasgn, :x])
    #   process([:lasgn, :x, [:lit, 123]])
    #
    # @param  [Array(Symbol), Array(Symbol, Array)] exp
    # @return [Variable, Operator::Assignment]
    def process_lasgn(exp)
      var, val = Variable.new(exp.shift), process(exp.shift)
      val ? Operator::Assignment.new(var, val) : var
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
      if exp.first == [:scope, [:block, [:nil]]] # HACK
        body = nil
      else
        body = process(exp.shift)
      end
      Function.new(name, args, body)
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
      Node.new(*exp.map { |var| Variable.new(var) })
    end

    ##
    # Processes `[:arglist, ...]` expressions.
    #
    # @example
    #   process([:arglist])
    #   process([:arglist, [:lit, 1]])
    #   process([:arglist, [:lit, 1], [:lit, 2]])
    #
    # @param  [Array<Array>] exp
    # @return [Node]
    def process_arglist(exp)
      Node.new(*exp.map { |val| process(val) })
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
    # @return [Block]
    def process_block(exp)
      Block.new(*exp.map { |exp| process(exp) })
    end

    ##
    # Processes `[:module, symbol, [:scope, ...]]` expressions.
    #
    # @example
    #   process{module Foo; end} == process([:module, :Foo, [:scope]])
    #
    # @param  [Array(Symbol, Array)] exp
    # @return [Class]
    def process_module(exp)
      Interface.new(exp.shift) # TODO
    end

    ##
    # Processes `[:class, symbol, parent, [:scope, ...]]` expressions.
    #
    # @example
    #   process{class Foo; end} == process([:class, :Foo, nil, [:scope]])
    #
    # @param  [Array(Symbol, Object, Array)] exp
    # @return [Class]
    def process_class(exp)
      Class.new(exp.shift, :extends => exp.first ? process(exp.first) : nil) # TODO
    end

    ##
    # Processes `[:const, symbol]` expressions.
    #
    # @example
    #   process([:const, :Foo])
    #
    # @param  [Array(Symbol)] exp
    # @return [Identifier]
    def process_const(exp)
      Identifier.new(exp.shift)
    end

    ##
    # Processes `[:return, [...]]` expressions.
    #
    # @example
    #   process([:return, [:nil]])
    #
    # @param  [Array] exp
    # @return [Statement::Return]
    def process_return(exp)
      Statement::Return.new(exp.empty? ? nil : process(exp.shift))
    end

    ##
    # Processes `[:if, condition, then_statement, else_statement]` expressions.
    #
    # @example
    #   process([:if, [:true], [:lit, 1], [:lit, 0]])
    #
    # @param  [Array(Array, Array, Array)] exp
    # @return [Statement::If]
    def process_if(exp)
      condition, then_branch, else_branch = exp
      case
        when else_branch.nil?
          Statement::If.new(process(condition), process(then_branch))
        when then_branch.nil?
          Statement::If.new(Operator::Logical::Not.new(process(condition)), process(else_branch))
        else
          Statement::If.new(process(condition), process(then_branch), process(else_branch))
      end
    end

    ##
    # Processes `[:for, iterable, variables, block]` expressions.
    #
    # @example
    #   process([:for, [:lvar, :numbers], [:lasgn, :number]])
    #
    # @param  [Array(Array, Array, Array)] exp
    # @return [Loop::ForEach]
    def process_for(exp)
      Loop::ForEach.new(process(exp.shift), process(exp.shift), process(exp.shift))
    end

    ##
    # Processes `[:while, condition, block]` expressions.
    #
    # @example
    #   process([:while, [:true], [:call, nil, :puts, [:arglist, [:str, "looping..."]]], true])
    #
    # @param  [Array(Array, Array, Boolean)] exp
    # @return [Loop::While]
    def process_while(exp)
      Loop::While.new(process(exp.shift), process(exp.shift))
    end

    ##
    # Processes `[:until, condition, block]` expressions.
    #
    # @example
    #   process([:until, [:false], [:call, nil, :puts, [:arglist, [:str, "looping..."]]], true])
    #
    # @param  [Array(Array, Array, Boolean)] exp
    # @return [Loop::While]
    def process_until(exp)
      Loop::While.new(Operator::Logical::Not.new(process(exp.shift)), process(exp.shift))
    end

    ##
    # Processes `[:not, operand]` expressions.
    #
    # @example
    #   process([:not, [:true]])
    #
    # @param  [Array(Array)] exp
    # @return [Operator::Logical::Not]
    def process_not(exp)
      Operator::Logical::Not.new(process(exp.shift))
    end

    ##
    # Processes `[:and, lhs, rhs]` expressions.
    #
    # @example
    #   process([:and, [:true], [:false]])
    #
    # @param  [Array(Array, Array)] exp
    # @return [Operator::Logical::And]
    def process_and(exp)
      Operator::Logical::And.new(process(exp.shift), process(exp.shift))
    end

    ##
    # Processes `[:or, lhs, rhs]` expressions.
    #
    # @example
    #   process([:or, [:true], [:false]])
    #
    # @param  [Array(Array, Array)] exp
    # @return [Operator::Logical::Or]
    def process_or(exp)
      Operator::Logical::Or.new(process(exp.shift), process(exp.shift))
    end

    ##
    # Processes `[:xstr, command]` expressions.
    #
    # @example
    #   process{`hostname`} == process([:xstr, 'hostname'])
    #
    # @param  [Array(String)] exp
    # @return [Operator::Execution]
    def process_xstr(exp)
      Operator::Execution.new(exp.shift)
    end

    ##
    # Processes `[:match2, pattern, subject]` expressions.
    #
    # @example
    #   process{/a-z/ =~ "a"} == process([:match2, [:lit, /a-z/], [:str, "a"]])
    #   process{/a-z/ =~ $x } == process([:match2, [:lit, /a-z/], [:gvar, :$x]])
    #
    # @param  [Array(Array, Array)] exp
    # @return [Operator::Regex::Match]
    def process_match2(exp)
      process_match3(exp)
    end

    ##
    # Processes `[:match3, pattern, subject]` expressions.
    #
    # @example
    #   process{"a" =~ /a-z/} == process([:match3, [:lit, /a-z/], [:str, "a"]])
    #   process{$x  =~ /a-z/} == process([:match3, [:lit, /a-z/], [:gvar, :$x]])
    #
    # @param  [Array(Array, Array)] exp
    # @return [Operator::Regex::Match]
    def process_match3(exp)
      Operator::Regex::Match.new(process(exp.shift), process(exp.shift))
    end
  end
end
