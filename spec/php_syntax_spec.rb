require File.join(File.dirname(__FILE__), 'spec_helper')

describe PHP::Identifier do
  context "when created" do
    it "should require a name argument" do
      lambda { PHP::Identifier.new }.should raise_error(ArgumentError)
      lambda { PHP::Identifier.new(:foo) }.should_not raise_error(ArgumentError)
    end

    it "should convert the name argument to a symbol" do
      PHP::Identifier.new('foo').name.should be_a_kind_of(Symbol)
      PHP::Identifier.new(123).name.should be_a_kind_of(Symbol)
    end
  end

  context "when output" do
    it "should correspond to the PHP representation" do
      PHP::Identifier.new(:count).to_php.should    == 'count'
      PHP::Identifier.new(:__FILE__).to_php.should == '__FILE__'
    end
  end
end
