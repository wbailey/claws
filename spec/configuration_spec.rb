require 'spec_helper'
require 'claws/configuration'

describe Claws::Configuration do
  let (:yaml) do
    {
      'capistrano' => {
        'home' => 'test',
      },
      'aws' => {
        'access_key_id' => 'asdf',
        'secret_access_key' => 'qwer',
        'aws_user' => 'test',
      },
      'ec2' => {
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
    }
  end

  let (:config) { Claws::Configuration.new }

  describe '#initialize' do
    it 'defines default path' do
      YAML.should_receive(:load_file).and_return( yaml )
      c = Claws::Configuration.new
      c.path.should == File.join(ENV['HOME'], '.claws.yml')
    end

    it 'defines a custom path' do
      YAML.should_receive(:load_file).and_return( yaml )
      c = Claws::Configuration.new '/home/test'
      c.path.should == '/home/test'
    end

    it 'raises ConfigurationError' do
      YAML.should_receive(:load_file).and_raise( Exception.new )

      expect {
        Claws::Configuration.new
      }.should raise_exception Claws::ConfigurationError
    end

    context 'Capistrano' do
      it 'defines home' do
        YAML.should_receive(:load_file).and_return(yaml)
        config.capistrano.home.should == 'test'
      end
    end

    context 'AWS' do
      before :each do
        YAML.should_receive(:load_file).and_return(yaml)
      end

      it 'defines user' do
        config.aws['aws_user'].should == 'test'
      end

      it 'defines secret access key' do
        config.aws['secret_access_key'].should == 'qwer'
      end

      it 'defines access key id' do
        config.aws['access_key_id'].should == 'asdf'
      end
    end

    context 'EC2' do
      before :each do
        YAML.should_receive(:load_file).and_return(yaml)
      end

      context 'fields' do
        it 'defines id hash' do
          id = config.ec2.fields['id']
          id['width'].should == 10
          id['title'].should == 'ID'
        end

        it 'defines name hash' do
          name = config.ec2.fields['name']
          name['width'].should == 20
          name['title'].should == 'Name'
        end
      end
    end
  end
end
