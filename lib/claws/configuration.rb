require 'yaml'
require 'ostruct'

module Claws
  class ConfigurationError < StandardError; end

  class Configuration
    attr_accessor :path, :capistrano, :ssh, :aws, :ec2

    def initialize(use_path = nil)
      self.path = use_path || File.join(ENV['HOME'], '.claws.yml')

      begin
        yaml = YAML.load_file(path)
      rescue Exception
        raise ConfigurationError, "Unable to locate configuration file: #{self.path}"
      end

      self.capistrano = OpenStruct.new( yaml['capistrano'] )
      self.ssh = OpenStruct.new( yaml['ssh'] )
      self.aws = yaml['aws']
      self.ec2 = OpenStruct.new(
        {
          :fields => yaml['ec2']['fields'],
          :regions => yaml['ec2']['regions'],
        }
      )
    end
  end
end
