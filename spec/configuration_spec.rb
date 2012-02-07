require 'spec_helper'
require 'claws/configuration'

describe Claws::Configuration do
  before :each do
    @yaml = {"capistrano_home"=>"test", "access_key_id"=>"asdf", "secret_access_key"=>"qwer"}
  end

  context 'defines capistrano home' do
    it 'using default path' do
      YAML.should_receive(:load_file).with("#{ENV['HOME']}/.claws.yml").and_return(@yaml)
      config = Claws::Configuration.new
      config.capistrano_home.should == 'test'
    end

    it 'using custom path' do
      YAML.should_receive(:load_file).and_return(@yaml)
      config = Claws::Configuration.new('another/path')
      config.capistrano_home.should == 'test'
    end
  end

  it 'defines AWS credentials' do
    YAML.should_receive(:load_file).and_return(@yaml)
    config = Claws::Configuration.new
    config.access_key_id.should == 'asdf'
    config.secret_access_key.should == 'qwer'
    config.aws_credentials.should == {:access_key_id => 'asdf', :secret_access_key => 'qwer'}
  end
end
