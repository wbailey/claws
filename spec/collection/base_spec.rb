require 'spec_helper'
require 'claws/collection/base'
require 'claws/configuration'

describe Claws::Collection::Base do
  subject { Claws::Collection::Base }

  before :each do
    @yaml = {"capistrano_home"=>"test", "access_key_id"=>"asdf", "secret_access_key"=>"qwer"}
    @credentials = {:access_key_id => 'asdf', :secret_access_key => 'qwer'}

    @config = double('Claws::Configuration', :aws_credentials => @credentials)
    AWS.should_receive(:config).with(@credentials).and_return(true)
    AWS.should_receive(:start_memoizing).and_return(nil)
  end

  it 'establishes a connection to the mothership' do

    expect {
      subject.connect(@config.aws_credentials)
    }.to_not raise_exception
  end

  it 'builds a collection'
end
