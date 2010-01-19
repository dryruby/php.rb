require 'php/version'

module PHP
  # Abstract Syntax Tree (AST) classes
  autoload :Class,      'php/syntax/class'
  autoload :Comment,    'php/syntax/comment'
  autoload :Constant,   'php/syntax/constant'
  autoload :Expression, 'php/syntax/expression'
  autoload :Function,   'php/syntax/function'
  autoload :Identifier, 'php/syntax/identifier'
  autoload :Interface,  'php/syntax/interface'
  autoload :Literal,    'php/syntax/literal'
  autoload :Namespace,  'php/syntax/namespace'
  autoload :Node,       'php/syntax/node'
  autoload :Operator,   'php/syntax/operator'
  autoload :Program,    'php/syntax/program'
  autoload :Statement,  'php/syntax/statement'
  autoload :Variable,   'php/syntax/variable'

  # PHP code generator
  autoload :Generator,  'php/generator'

  ##
  # Evaluates a given block of code by invoking the `php` executable.
  #
  # @param  [Hash{Symbol => Object}] options
  # @option options [IO, #<<] :stdout ($stdout)
  # @option options [IO, #<<] :stderr ($stderr)
  # @yield
  # @return [void]
  def self.eval(options = {}, &block)
    if php = PHP::Program.new(PHP::Generator.process(&block)) # FIXME
      self.exec(php, options)
    end
  end

  ##
  # Executes a PHP program by invoking the `php` executable.
  #
  # @param  [Program, String, #to_s] program
  # @param  [Hash{Symbol => Object}] options
  # @option options [IO, #<<] :stdout ($stdout)
  # @option options [IO, #<<] :stderr ($stderr)
  # @return [Process::Status]
  def self.exec(program, options = {})
    require 'open4' unless defined?(Open4)
    Open4::spawn('php', {:stdin => program.to_s, :stdout => $stdout, :stderr => $stderr}.merge(options))
  end
end
