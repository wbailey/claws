require 'spec_helper'
require 'claws/capistrano'

describe Claws::Capistrano do
  let(:default_path) { 'config/deploy' }

  let(:roles) do
    {
      staging: [
        "role :app, 'ec2-175-65-213-31.compute-1.amazonaws.com'",
        "role :web, 'ec2-175-65-213-31.compute-1.amazonaws.com'",
        "role :batch, 'ec2-175-65-213-31.compute-1.amazonaws.com'",
        "role :redis, 'ec2-223-40-143-23.compute-1.amazonaws.com'",
        "role :search, 'ec2-147-32-151-54.compute-1.amazonaws.com'",
        "role :search_slave, 'ec2-147-32-151-54.compute-1.amazonaws.com'"
      ],
      production: [
        "role :app, 'ec2-263-56-231-91.compute-1.amazonaws.com', 'ec2-263-23-118-57.compute-1.amazonaws.com'",
        "role :web, 'ec2-263-56-231-91.compute-1.amazonaws.com', 'ec2-263-23-118-57.compute-1.amazonaws.com', 'ec2-23-20-43-198.compute-1.amazonaws.com'",
        "role :batch, 'ec2-23-20-43-198.compute-1.amazonaws.com'",
        "role :redis, 'ec2-23-20-43-198.compute-1.amazonaws.com'",
        "role :search, 'ec2-107-21-131-545.compute-1.amazonaws.com'",
        "role :search_slave, 'ec2-263-23-144-120.compute-1.amazonaws.com'"
      ]
    }
  end

  let(:mappings) do
    {
      staging: {
        'ec2-175-65-213-31.compute-1.amazonaws.com' => %w[app web batch],
        'ec2-223-40-143-23.compute-1.amazonaws.com' => %w[redis],
        'ec2-147-32-151-54.compute-1.amazonaws.com' => %w[search search_slave]
      },
      production: {
        'ec2-263-56-231-91.compute-1.amazonaws.com' => %w[app web],
        'ec2-263-23-118-57.compute-1.amazonaws.com' => %w[app web],
        'ec2-23-20-43-198.compute-1.amazonaws.com' => %w[web batch redis],
        'ec2-107-21-131-545.compute-1.amazonaws.com' => %w[search],
        'ec2-263-23-144-120.compute-1.amazonaws.com' => %w[search_slave]
      }
    }
  end

  context 'defines roles hash per environment per host' do
    it 'from default path' do
      allow(Dir).to receive(:glob).and_return(%W[#{default_path}/staging.rb #{default_path}/production.rb])
      allow(File).to receive(:readlines).with("#{default_path}/staging.rb").and_return(roles[:staging])
      allow(File).to receive(:readlines).with("#{default_path}/production.rb").and_return(roles[:production])

      cap = Claws::Capistrano.new
      expect(cap.home).to eq(default_path)
      expect(cap.all_host_roles).to eq(mappings)
    end

    it 'from custom path' do
      custom_path = '/home/app/config/deploy'
      allow(Dir).to receive(:glob).and_return(%W[#{custom_path}/staging.rb #{custom_path}/production.rb])
      allow(File).to receive(:readlines).with("#{custom_path}/staging.rb").and_return(roles[:staging])
      allow(File).to receive(:readlines).with("#{custom_path}/production.rb").and_return(roles[:production])

      cap = Claws::Capistrano.new(custom_path)
      expect(cap.home).to eq(custom_path)
      expect(cap.all_host_roles).to eq(mappings)
    end
  end

  it 'returns roles for host' do
    allow(Dir).to receive(:glob).and_return(%W[#{default_path}/staging.rb #{default_path}/production.rb])
    allow(File).to receive(:readlines).with("#{default_path}/staging.rb").and_return(roles[:staging])
    allow(File).to receive(:readlines).with("#{default_path}/production.rb").and_return(roles[:production])

    cap = Claws::Capistrano.new
    expect(cap.roles('ec2-263-56-231-91.compute-1.amazonaws.com')).to eq(%w[app web])
  end
end
