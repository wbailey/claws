require 'spec_helper'
require 'claws/collection/base'
require 'claws/configuration'

describe Claws::Collection::Base do
  subject { Claws::Collection::Base }

  let(:credentials) do
    {
      :access_key_id => 'asdf',
      :secret_access_key => 'qwer'
    }
  end

  let(:config) do
    double('Claws::Configuration', :aws => credentials)
  end

  it 'establishes a connection to the mothership' do
    AWS.should_receive(:config).with(credentials).and_return(true)
    AWS.should_receive(:start_memoizing).and_return(nil)

    expect {
      subject.new(config)
    }.to_not raise_exception
  end
end
