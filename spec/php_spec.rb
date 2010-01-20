require File.join(File.dirname(__FILE__), 'spec_helper')

describe PHP do
  it "should return the PHP version number" do
    PHP.should respond_to(:version)
    PHP.version.should be_a_kind_of(String)
    PHP.version.should_not be_empty
    PHP.version.should match(/^\d+\.\d+\.\d+$/)
  end

  context "generating PHP programs" do
    it "should support generating empty programs" do
      PHP.generate{}.should be_a_kind_of(PHP::Program)
      PHP.generate{}.to_s.should == "<?php\n"
    end
  end

  context "evaluating PHP programs" do
    # TODO
  end
end
