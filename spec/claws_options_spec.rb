require 'spec_helper'
require 'claws/options'

ARGV.clear

def cli(args)
  ARGV.push(*args)
  yield
  ARGV.clear
end

describe Claws::Options do
  it 'defines default options' do
    cli %w{production app} do
      options = Claws::Options.parse
      options.connect.should be_true
      options.source.should == 'ec2'
      options.choice.should be_nil
    end
  end

  it 'accepts display only flag' do
    # By default we want to connect to the instance
    Claws::Options.parse.connect.should be_true

    # Allow the user to override and just display information
    cli %w{-d} do
      Claws::Options.parse.connect.should be_false
    end

    cli %w{--display-only} do
      Claws::Options.parse.connect.should be_false
    end
  end

  it 'accepts a choice flag' do
    cli %w{-c 10} do
      Claws::Options.parse.choice.should == 10
    end

    cli %w{--choice 10} do
      Claws::Options.parse.choice.should == 10
    end
  end

  it 'accepts a source flag' do
    cli %w{-s elb} do
      options = Claws::Options.parse
      options.source.should == 'elb'
      options.connect.should be_false
    end

    cli %w{--source elb} do
      options = Claws::Options.parse
      options.source.should == 'elb'
      options.connect.should be_false
    end
  end

  context 'capistrano' do
    it 'defines the environment' do
      cli %w{-s production app} do
        Claws::Options.parse.environment.should == 'production'
      end
    end

    it 'defines the role' do
      cli %w{-s production app} do
        Claws::Options.parse.role.should == 'app'
      end
    end
  end
end
