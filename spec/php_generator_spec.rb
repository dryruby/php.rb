require File.join(File.dirname(__FILE__), 'spec_helper')

describe PHP::Generator do
  context "literals" do
    it "should support null literals" do
      php('nil').to_s.should == 'NULL'
      php{ nil }.to_s.should == 'NULL'
    end

    it "should support boolean literals" do
      php('false').to_s.should == 'FALSE'
      php{ false }.to_s.should == 'FALSE'
      php('true').to_s.should  == 'TRUE'
      php{ true }.to_s.should  == 'TRUE'
    end

    it "should support integer literals" do
      php('42').to_s.should == '42'
      php{ 42 }.to_s.should == '42'
    end

    it "should support float literals" do
      php('3.1415').to_s.should == '3.1415'
      php{ 3.1415 }.to_s.should == '3.1415'
    end

    it "should support string literals" do
      php("''").to_s.should == '""'
      php{ '' }.to_s.should == '""'
      php('""').to_s.should == '""'
      php{ "" }.to_s.should == '""'
      php("'Hello, world!'").to_s.should == '"Hello, world!"'
      php{ 'Hello, world!' }.to_s.should == '"Hello, world!"'
    end
  end

  context "identifiers" do
    it "should support identifiers" do
      php(':foo').to_s.should == 'foo'
      php{ :foo }.to_s.should == 'foo'
    end
  end

  context "global variables" do
    it "should support global variables" do
      php('$foo').to_s.should == "$GLOBALS['foo']"
      php{ $foo }.to_s.should == "$GLOBALS['foo']"
    end

    it "should support global variable assignments"
  end

  context "local variables" do
    it "should support local variables" do
      php('foo').to_s.should == '$foo'
      #php{ foo }.to_s.should == '$foo' # FIXME
    end

    it "should support local variable assignments"
  end

  context "anonymous functions" do
    it "should support functions of zero arguments" do
      php('lambda {}').to_s.should == 'function() {}'
      php{ lambda {} }.to_s.should == 'function() {}'
    end

    it "should support functions of one argument" do
      php('lambda { |x| }').to_s.should == 'function($x) {}'
      php{ lambda { |x| } }.to_s.should == 'function($x) {}'
    end

    it "should support functions of many arguments" do
      php('lambda { |x, y| }').to_s.should == 'function($x, $y) {}'
      php{ lambda { |x, y| } }.to_s.should == 'function($x, $y) {}'
    end

    it "should support functions of variable arity"
  end

  context "named functions" do
    it "should support functions of zero arguments" do
      php('def foo; end').to_s.should == 'function foo() {}'
      php{ def foo; end }.to_s.should == 'function foo() {}'
      php('def foo(); end').to_s.should == 'function foo() {}'
      php{ def foo(); end }.to_s.should == 'function foo() {}'
    end

    it "should support functions of one argument" do
      php('def foo(x); end').to_s.should == 'function foo($x) {}'
      php{ def foo(x); end }.to_s.should == 'function foo($x) {}'
    end

    it "should support functions of many arguments" do
      php('def foo(x, y); end').to_s.should == 'function foo($x, $y) {}'
      php{ def foo(x, y); end }.to_s.should == 'function foo($x, $y) {}'
    end

    it "should support functions of variable arity"
  end

  def php(input = nil, &block)
    if block_given?
      PHP::Generator.process(&block)
    else
      PHP::Generator.process(input)
    end
  end
end
