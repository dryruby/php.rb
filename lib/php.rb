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
end
