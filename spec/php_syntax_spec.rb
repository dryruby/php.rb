require File.join(File.dirname(__FILE__), 'spec_helper')

describe PHP::Node do
  it "should not be instantiable" do
    lambda { PHP::Node.new }.should raise_error(NoMethodError)
  end
end

describe PHP::Identifier do
  context "when created" do
    it "should require an identifier name" do
      lambda { PHP::Identifier.new }.should raise_error(ArgumentError)
      lambda { PHP::Identifier.new(:foo) }.should_not raise_error(ArgumentError)
    end

    it "should reject invalid identifier names" do
      lambda { PHP::Identifier.new(123) }.should raise_error(ArgumentError)
      lambda { PHP::Identifier.new('4site') }.should raise_error(ArgumentError)
    end

    it "should accept valid identifier names" do
      lambda { PHP::Identifier.new('var') }.should_not raise_error(ArgumentError)
      lambda { PHP::Identifier.new('Var') }.should_not raise_error(ArgumentError)
      lambda { PHP::Identifier.new('_4site') }.should_not raise_error(ArgumentError)
    end

    it "should convert the identifier name to a symbol" do
      PHP::Identifier.new(:foo).name.should be_a_kind_of(Symbol)
      PHP::Identifier.new('foo').name.should be_a_kind_of(Symbol)
    end
  end

  context "when output" do
    it "should correspond to the PHP representation" do
      PHP::Identifier.new(:count).to_php.should    == 'count'
      PHP::Identifier.new(:__FILE__).to_php.should == '__FILE__'
    end
  end
end

describe PHP::Variable do
  context "when created" do
    it "should require a variable name" do
      lambda { PHP::Variable.new }.should raise_error(ArgumentError)
      lambda { PHP::Variable.new(:foo) }.should_not raise_error(ArgumentError)
    end

    it "should reject invalid variable names" do
      lambda { PHP::Variable.new(123) }.should raise_error(ArgumentError)
      lambda { PHP::Variable.new('4site') }.should raise_error(ArgumentError)
      lambda { PHP::Variable.new('$site') }.should raise_error(ArgumentError)
    end

    it "should accept valid variable names" do
      lambda { PHP::Variable.new('var') }.should_not raise_error(ArgumentError)
      lambda { PHP::Variable.new('Var') }.should_not raise_error(ArgumentError)
      lambda { PHP::Variable.new('_4site') }.should_not raise_error(ArgumentError)
    end

    it "should convert the variable name to a symbol" do
      PHP::Variable.new(:foo).name.should be_a_kind_of(Symbol)
      PHP::Variable.new('foo').name.should be_a_kind_of(Symbol)
    end
  end

  context "global variables" do
    it "should correspond to their PHP representation" do
      PHP::Variable.new(:count, :global => true).to_php.should == "$GLOBALS['count']"
    end
  end

  context "local variables" do
    it "should correspond to their PHP representation" do
      PHP::Variable.new(:count).to_php.should == '$count'
      PHP::Variable.new(PHP::Variable.new(:function)).to_php.should == '$$function'
    end
  end
end

describe PHP::Literal do
  context "when created" do
    it "should require a literal value" do
      lambda { PHP::Literal.new }.should raise_error(ArgumentError)
      lambda { PHP::Literal.new(123) }.should_not raise_error(ArgumentError)
    end
  end

  context "null literals" do
    it "should correspond to their PHP representation" do
      PHP::Literal.new(nil).to_php.should == 'NULL'
    end
  end

  context "boolean literals" do
    it "should correspond to their PHP representation" do
      PHP::Literal.new(true).to_php.should  == 'TRUE'
      PHP::Literal.new(false).to_php.should == 'FALSE'
    end
  end

  context "integer literals" do
    it "should correspond to their PHP representation" do
      PHP::Literal.new(123).to_php.should == '123'
    end
  end

  context "float literals" do
    it "should correspond to their PHP representation" do
      PHP::Literal.new(3.1415).to_php.should == '3.1415'
    end
  end

  context "string literals" do
    it "should correspond to their PHP representation" do
      PHP::Literal.new('Hello, world!').to_php.should == '"Hello, world!"'
      PHP::Literal.new('""').to_php.should == '"\\"\\""'
    end
  end
end

describe PHP::Interface do
  context "when created" do
    it "should require an interface name" do
      lambda { PHP::Interface.new }.should raise_error(ArgumentError)
      lambda { PHP::Interface.new(:foo) }.should_not raise_error(ArgumentError)
    end
  end
end

describe PHP::Class do
  context "when created" do
    it "should require a class name" do
      lambda { PHP::Class.new }.should raise_error(ArgumentError)
      lambda { PHP::Class.new(:foo) }.should_not raise_error(ArgumentError)
    end
  end
end

describe PHP::Function do
  context "when created" do
    it "should accept a function name" do
      lambda { PHP::Function.new }.should_not raise_error(ArgumentError)
      lambda { PHP::Function.new(:foo) }.should_not raise_error(ArgumentError)
    end
  end
end

describe PHP::Program do
  context "when created" do
    it "should accept list of statements" do
      lambda { PHP::Program.new }.should_not raise_error(ArgumentError)
    end
  end
end
