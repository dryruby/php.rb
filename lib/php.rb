require 'php/version'

module PHP
  # Abstract Syntax Tree (AST) classes
  autoload :Block,      'php/syntax/block'
  autoload :Class,      'php/syntax/class'
  autoload :Comment,    'php/syntax/comment'
  autoload :Constant,   'php/syntax/constant'
  autoload :Expression, 'php/syntax/expression'
  autoload :Function,   'php/syntax/function'
  autoload :Identifier, 'php/syntax/identifier'
  autoload :Interface,  'php/syntax/interface'
  autoload :Literal,    'php/syntax/literal'
  autoload :Loop,       'php/syntax/loop'
  autoload :Method,     'php/syntax/method'
  autoload :Namespace,  'php/syntax/namespace'
  autoload :Node,       'php/syntax/node'
  autoload :Operator,   'php/syntax/operator'
  autoload :Program,    'php/syntax/program'
  autoload :Statement,  'php/syntax/statement'
  autoload :Variable,   'php/syntax/variable'

  # PHP code generator
  autoload :Generator,  'php/generator'

  ##
  # Returns the current PHP version by invoking the `php` executable.
  #
  # @example
  #   PHP.version   #=> "5.3.1"
  #
  # @return [String]
  def self.version
    version = ''
    self.exec('<?php echo phpversion();', :stdout => version)
    version.size > 0 ? version : nil
  end

  ##
  # Evaluates a given block of code by invoking the `php` executable.
  #
  # @param  [Hash{Symbol => Object}] options
  # @option options [IO] :stdout ($stdout)
  # @option options [IO] :stderr ($stderr)
  # @yield
  # @return [void]
  def self.eval(options = {}, &block)
    self.exec(self.generate(&block), options)
  end

  ##
  # Executes a PHP program by invoking the `php` executable.
  #
  # @param  [Program, String, #to_s] program
  # @param  [Hash{Symbol => Object}] options
  # @option options [IO] :stdout ($stdout)
  # @option options [IO] :stderr ($stderr)
  # @return [Process::Status]
  def self.exec(program, options = {})
    require 'open4' unless defined?(Open4)
    Open4::spawn('php', {:stdin => program.to_s, :stdout => $stdout, :stderr => $stderr}.merge(options))
  end

  ##
  # Outputs the given block of code translated into PHP code.
  #
  # @overload dump(input, options = {})
  #   @param  [String] input
  #   @param  [Hash{Symbol => Object}] options
  #
  # @overload dump(options = {}, &block)
  #   @yield
  #   @param  [Hash{Symbol => Object}] options
  #
  # @return [void]
  def self.dump(input = nil, options = {}, &block)
    puts self.generate(input, options, &block).to_s
  end

  ##
  # Translates the given block of code into abstract PHP code.
  #
  # @overload generate(input, options = {})
  #   @param  [String] input
  #   @param  [Hash{Symbol => Object}] options
  #
  # @overload generate(options = {}, &block)
  #   @yield
  #   @param  [Hash{Symbol => Object}] options
  #
  # @return [Program]
  def self.generate(input = nil, options = {}, &block)
    if php = PHP::Generator.process(input, options, &block)
      PHP::Program.new(php)
    else
      PHP::Program.new
    end
  end
end
