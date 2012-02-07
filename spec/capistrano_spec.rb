require 'spec_helper'
require 'claws/capistrano'

describe Claws::Capistrano do
  context 'defines roles hash per environment per host' do
    before :each do
      @roles = {
        :staging => [
          %q{role :app, 'ec2-175-65-213-31.compute-1.amazonaws.com'},
          %q{role :web, 'ec2-175-65-213-31.compute-1.amazonaws.com'},
          %q{role :batch, "ec2-175-65-213-31.compute-1.amazonaws.com"},
          %q{role :redis, "ec2-223-40-143-23.compute-1.amazonaws.com"},
          %q{role :search, "ec2-147-32-151-54.compute-1.amazonaws.com"},
          %q{role :search_slave, "ec2-147-32-151-54.compute-1.amazonaws.com"},
        ],

        :production => [
          %q{role :app, "ec2-263-56-231-91.compute-1.amazonaws.com", 'ec2-263-23-118-57.compute-1.amazonaws.com'},
          %q{role :web, "ec2-263-56-231-91.compute-1.amazonaws.com", 'ec2-263-23-118-57.compute-1.amazonaws.com', "ec2-23-20-43-198.compute-1.amazonaws.com"},
          %q{role :batch, "ec2-23-20-43-198.compute-1.amazonaws.com"},
          %q{role :redis, "ec2-23-20-43-198.compute-1.amazonaws.com"},
          %q{role :search, "ec2-107-21-131-545.compute-1.amazonaws.com"},
          %q{role :search_slave, "ec2-263-23-144-120.compute-1.amazonaws.com"},
        ]
      }
      @mappings = {
        :staging => {
          'ec2-175-65-213-31.compute-1.amazonaws.com' => %w{app web batch},
          'ec2-223-40-143-23.compute-1.amazonaws.com' => %w{redis},
          'ec2-147-32-151-54.compute-1.amazonaws.com' => %w{search search_slave},
        },
        :production => {
          'ec2-263-56-231-91.compute-1.amazonaws.com' => %w{app web},
          'ec2-263-23-118-57.compute-1.amazonaws.com' => %w{app web},
          'ec2-23-20-43-198.compute-1.amazonaws.com' => %w{web batch redis},
          'ec2-107-21-131-545.compute-1.amazonaws.com' => %w{search},
          'ec2-263-23-144-120.compute-1.amazonaws.com' => %w{search_slave},
        },
      }
    end

    it 'from default path' do
      default_path = 'config/deploy'

      Dir.should_receive(:glob).and_return(%W{#{default_path}/staging.rb #{default_path}/production.rb})
      File.should_receive(:readlines).with("#{default_path}/staging.rb").and_return(@roles[:staging])
      File.should_receive(:readlines).with("#{default_path}/production.rb").and_return(@roles[:production])

      cap = Claws::Capistrano.new
      cap.home.should == default_path
      cap.server_roles.should == @mappings
    end

    it 'from custom path' do
      custom_path = '/home/app/config/deploy'
      Dir.should_receive(:glob).and_return(%W{#{custom_path}/staging.rb #{custom_path}/production.rb})
      File.should_receive(:readlines).with("#{custom_path}/staging.rb").and_return(@roles[:staging])
      File.should_receive(:readlines).with("#{custom_path}/production.rb").and_return(@roles[:production])

      cap = Claws::Capistrano.new(custom_path)
      cap.home.should == custom_path
      cap.server_roles.should == @mappings
    end
  end
end
