require 'spec_helper'
require 'claws/configuration'

describe Claws::Configuration do
  let (:yaml) do
    {
      'capistrano_home' => 'test',
      'access_key_id' => 'asdf',
      'secret_access_key' => 'qwer',
      'aws_user' => 'test',
      'fields' => {
        'id' => {
          'width' => 10,
          'title' => 'ID'
        },
        'name' => {
          'width' => 20,
          'title' => 'Name'
        },
      }
    }
  end

  let (:config) { Claws::Configuration.new }

  context 'defines capistrano home' do
    it 'using default path' do
      YAML.should_receive(:load_file).with("#{ENV['HOME']}/.claws.yml").and_return(yaml)
      config.capistrano_home.should == 'test'
    end

    it 'using custom path' do
      YAML.should_receive(:load_file).and_return(yaml)
      config.capistrano_home.should == 'test'
    end
  end

  context 'defines AWS credentials' do
    before :each do
      YAML.should_receive(:load_file).and_return(yaml)
    end

    it 'access key id' do
      config.access_key_id.should == 'asdf'
    end

    it 'secret access key' do
      config.secret_access_key.should == 'qwer'
    end

    it 'user' do
      config.aws_user.should == 'test'
    end

    it 'hash' do
      config.aws_credentials.should == {:access_key_id => 'asdf', :secret_access_key => 'qwer'}
    end
  end

  context 'defines display fields' do
    before :each do
      YAML.should_receive(:load_file).and_return(yaml)
    end

    it 'id' do
      id = config.fields['id']
      id.width.should == 10
      id.title.should == 'ID'
    end

    it 'name' do
      name = config.fields['name']
      name.width.should == 20
      name.title.should == 'Name'
    end
  end
end
