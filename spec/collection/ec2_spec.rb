require 'spec_helper'
require 'aws-sdk'
require 'claws/collection/ec2'

describe Claws::Collection::EC2 do
  subject { Claws::Collection::EC2 }

  let(:credentials) do
    {
      :access_key_id => 'asdf',
      :secret_access_key => 'qwer'
    }
  end

  let(:regions) do
    [
      double('AWS::EC2::Region',
        :name => 'us-east-1',
        :instances => 
          [
            double('AWS::EC2::Instance'),
            double('AWS::EC2::Instance'),
          ]
      ),
      double('AWS::EC2::Region',
        :name => 'eu-east-1',
        :instances => 
          [
            double('AWS::EC2::Instance'),
            double('AWS::EC2::Instance'),
          ]
      ),
    ]
  end

  context 'gets all instances in regions' do
    it 'not defined in configuration' do
      AWS.should_receive(:config).with(credentials).and_return(true)
      AWS.should_receive(:start_memoizing).and_return(nil)

      AWS::EC2.should_receive(:new).and_return(
        double('AWS::EC2::RegionsCollection', :regions => regions)
      )

      config = double('Claws::Configuration',
        :aws => credentials,
        :ec2 => OpenStruct.new({:regions => nil})
      )

      subject.new(config).get.size.should == 4
    end

    it 'defined in configuation' do
      AWS.should_receive(:config).with(credentials).and_return(true)
      AWS.should_receive(:start_memoizing).and_return(nil)

      AWS::EC2.should_receive(:new).and_return(
        double('AWS::EC2::RegionsCollection', :regions => regions)
      )

      config = double('Claws::Configuration',
        :aws => credentials,
        :ec2 => OpenStruct.new({:regions => %w(us-east-1 eu-east-1)})
      )

      subject.new(config).get.size.should == 4
    end
  end

  it 'gets all instances for specified regions' do
    AWS.should_receive(:config).with(credentials).and_return(true)
    AWS.should_receive(:start_memoizing).and_return(nil)

    AWS::EC2.should_receive(:new).and_return(
      double('AWS::EC2::RegionsCollection', :regions => regions)
    )

    config = double('Claws::Configuration',
      :aws => credentials,
      :ec2 => OpenStruct.new({:regions => %w(us-east-1)})
    )

    subject.new(config).get.size.should == 2
  end
end
