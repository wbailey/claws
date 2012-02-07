require 'spec_helper'
require 'claws/options'

describe Claws::Options do
  it 'defines default options' do
    options = OpenStruct.new(
      {
        :connect => true,
        :source => 'ec2',
        :choice => nil,
      }
    )

    Claws::Options.parse.should == options
  end

  it 'accepts status only flag' do
    # By default we want to connect to the instance
    Claws::Options.parse.connect.should be_true

    # Allow the user to override and just display information
    ARGV = %w{script/claws -s}
    Claws::Options.parse.connect.should be_false
    ARGV = %w{script/claws --status}
    Claws::Options.parse.connect.should be_false
  end
end
