require File.join(File.dirname(__FILE__), 'spec_helper')

describe PHP::Generator do
  it "should support null literals" do
    php('nil').to_s.should == 'NULL'
  end

  it "should support boolean literals" do
    php('false').to_s.should == 'FALSE'
    php('true').to_s.should  == 'TRUE'
  end

  def php(input = nil, &block)
    if block_given?
      PHP::Generator.process(&block)
    else
      PHP::Generator.process(input)
    end
  end
end
