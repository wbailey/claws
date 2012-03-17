require 'spec_helper'
require 'aws-sdk'
require 'claws/collection/ec2'

describe Claws::Collection::EC2 do
  subject { Claws::Collection::EC2 }

  it 'gets all instances' do
    AWS::EC2.should_receive(:instances).with(no_args).and_return(
      [
        double('AWS::EC2::Instance'),
        double('AWS::EC2::Instance'),
      ]
    )
    # Claws::EC2::Proxy

    subject.get.size.should == 2
  end
end
