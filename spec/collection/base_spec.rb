require 'spec_helper'
require 'claws/collection/base'
require 'claws/configuration'

describe Claws::Collection::Base, '#initialize' do
  subject { Claws::Collection::Base }

  it 'establishes a connection to the mothership' do
    credentials = { access_key_id: 'asdf', secret_access_key: 'qwer' }
    config = double('Claws::Configuration', aws: credentials)

    allow(Aws).to receive_message_chain(:config, :update)

    expect { subject.new(config) }.to_not raise_exception
  end
end
