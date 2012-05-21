require 'spec_helper'
require 'claws/command/ec2'

describe Claws::Command::EC2 do
  subject { Claws::Command::EC2 }

  describe '#exec' do
    it 'handles invalid configuration files' do
      subject.should_receive(:exec).and_raise(Claws::ConfigurationError)

      expect {
        subject.exec
      }.should raise_exception Claws::ConfigurationError
    end
  end
end
