module PHP
  ##
  # @see http://en.wikipedia.org/wiki/Abstract_syntax_tree
  # @abstract
  class Node
    include Enumerable
    include Comparable

    ##
    # @return [Array<Node>]
    attr_accessor :children

    ##
    # @param  [Array<Node>] children
    def initialize(*children)
      @children = children
    end

    ##
    # Returns `true` if this AST node contains any child nodes.
    #
    # @return [Boolean]
    def children?
      @children && @children.size > 0
    end

    ##
    # Executes the given block once for each child node of this AST node.
    #
    # @yield  [node]
    # @yieldparam [Node] node
    # @return [Enumerator]
    def each(&block)
      children.each(&block)
    end

    ##
    # Appends a new child `node` to this AST node.
    #
    # @param  [Node] node
    # @return [Node]
    def <<(node)
      children << node
      self
    end

    ##
    # Compares this AST node to `other` for sorting purposes.
    #
    # @return [Integer] -1, 0, 1
    # @abstract
    def <=>(other)
      raise NotImplementedError
    end

    ##
    # Returns the indentation level for this AST node.
    #
    # @return [Integer]
    def indent
      @indent ||= 0
    end

    ##
    # Defines the indentation level for this AST node.
    #
    # @param  [Integer]
    # @return [void]
    def indent=(value)
      @indent = value
    end

    ##
    # Returns the PHP representation of this AST node.
    #
    # @return [String]
    # @abstract
    def to_php
      raise NotImplementedError
    end

    ##
    # Returns the string representation of this AST node.
    #
    # @return [String]
    def to_s
      to_php
    end

    private

      # Prevent the instantiation of this class:
      #private_class_method :new

      def self.inherited(child) # @private
        # Enable the instantiation of any subclasses:
        child.send(:public_class_method, :new)
        super
      end

  end
end
