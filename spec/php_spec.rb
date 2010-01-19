require File.join(File.dirname(__FILE__), 'spec_helper')

describe PHP do
  it "should return the PHP version number" do
    PHP.should respond_to(:version)
    PHP.version.should be_a_kind_of(String)
    PHP.version.should_not be_empty
    PHP.version.should match(/^\d+\.\d+\.\d+$/)
  end
end
