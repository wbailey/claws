require 'yaml'

module Claws
  class Configuration
    attr_accessor :path, :capistrano_home, :access_key_id, :secret_access_key

    def initialize(path = nil)
      self.path = path || File.join(ENV['HOME'], '.claws.yml')
      yaml = YAML.load_file(path)
      self.capistrano_home = yaml['capistrano_home']
      self.access_key_id = yaml['access_key_id']
      self.secret_access_key = yaml['secret_access_key']
    end
  end
end
