require 'spec_helper'
require 'claws/options'

def cli(args)
  ARGV.push(*args)
  yield
  ARGV.clear
end

describe Claws::Options do
  it 'defines default options' do
    cli %w{production app} do
      options = Claws::Options.parse
      expect(options.connect).to be(true)
      expect(options.source).to eq('ec2')
      expect(options.selection).to be(nil)
    end
  end

  it 'accepts display only flag' do
    # By default we want to connect to the instance
    expect(Claws::Options.parse.connect).to be(true)

    # Allow the user to override and just display information
    cli %w{-d} do
      expect(Claws::Options.parse.connect).to be(false)
    end

    cli %w{--display-only} do
      expect(Claws::Options.parse.connect).to be(false)
    end
  end

  it 'accepts a choice flag' do
    cli %w{-c 10} do
      expect(Claws::Options.parse.selection).to eq(10)
    end

    cli %w{--choice 10} do
      expect(Claws::Options.parse.selection).to eq(10)
    end
  end

  it 'accepts a source flag' do
    cli %w{-s elb} do
      options = Claws::Options.parse
      expect(options.source).to eq('elb')
    end

    cli %w{--source elb} do
      options = Claws::Options.parse
      expect(options.source).to eq('elb')
    end
  end

  context 'capistrano' do
    it 'defines the environment' do
      cli %w{production app} do
        expect(Claws::Options.parse.environment).to eq('production')
      end
    end

    it 'defines the role' do
      cli %w{production app} do
        expect(Claws::Options.parse.role).to eq('app')
      end
    end
  end
end
