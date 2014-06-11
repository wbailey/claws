require 'spec_helper'
require 'claws/configuration'

describe Claws::Configuration do
  let (:yaml) do
    {
      'capistrano' => {
        'home' => 'test',
      },
      'ssh' => {
        'user' => 'test',
        'identity' => 'test/id_rsa',
      },
      'aws' => {
        'access_key_id' => 'asdf',
        'secret_access_key' => 'qwer',
        'aws_user' => 'test',
      },
      'ec2' => {
        'regions' => [
          'us-east-1',
          'eu-east-1',
        ],
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
      expect(YAML).to receive(:load_file).and_return( yaml )
      c = Claws::Configuration.new
      expect(c.path).to eq(File.join(ENV['HOME'], '.claws.yml'))
    end

    it 'defines a custom path' do
      expect(YAML).to receive(:load_file).and_return( yaml )
      c = Claws::Configuration.new '/home/test'
      expect(c.path).to eq('/home/test')
    end

    it 'raises ConfigurationError' do
      expect(YAML).to receive(:load_file).and_raise( Exception.new )

      expect {
        Claws::Configuration.new
      }.to raise_exception(Claws::ConfigurationError)
    end

    context 'Capistrano' do
      it 'defines home' do
        expect(YAML).to receive(:load_file).and_return(yaml)
        expect(config.capistrano.home).to eq('test')
      end
    end

    context 'SSH' do
      before :each do
        expect(YAML).to receive(:load_file).and_return(yaml)
      end

      it 'defines user' do
        expect(config.ssh.user).to eq('test')
      end

      it 'defines the identity file' do
        expect(config.ssh.identity).to eq('test/id_rsa')
      end
    end

    context 'AWS' do
      before :each do
        expect(YAML).to receive(:load_file).and_return(yaml)
      end

      it 'defines user' do
        expect(config.aws['aws_user']).to eq('test')
      end

      it 'defines secret access key' do
        expect(config.aws['secret_access_key']).to eq('qwer')
      end

      it 'defines access key id' do
        expect(config.aws['access_key_id']).to eq('asdf')
      end
    end

    context 'EC2' do
      before :each do
        expect(YAML).to receive(:load_file).and_return(yaml)
      end

      it 'defines regions' do
        regions = config.ec2.regions
        expect(regions[0]).to eq('us-east-1')
        expect(regions[1]).to eq('eu-east-1')
      end

      context 'fields' do
        it 'defines id hash' do
          id = config.ec2.fields['id']
          expect(id['width']).to eq(10)
          expect(id['title']).to eq('ID')
        end

        it 'defines name hash' do
          name = config.ec2.fields['name']
          expect(name['width']).to eq(20)
          expect(name['title']).to eq('Name')
        end
      end
    end
  end
end
