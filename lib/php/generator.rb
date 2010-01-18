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
    # @return [Program]
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
      self.auto_shift_type = true
      self.strict          = false # FIXME
      self.require_empty   = false
      self.expected        = Node
    end
  end
end
