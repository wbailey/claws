require 'yaml'

module Claws
  class Configuration
    attr_accessor :path, :capistrano_home, :access_key_id, :secret_access_key

    def initialize(use_path = nil)
      self.path = use_path || File.join(ENV['HOME'], '.claws.yml')
      yaml = YAML.load_file(path)
      self.capistrano_home = yaml['capistrano_home']
      self.access_key_id = yaml['access_key_id']
      self.secret_access_key = yaml['secret_access_key']
      self.fields = yaml['fields']
    end

    def fields= fields
      @fields = fields.inject({}) {|h,v| h.merge({v[0] => OpenStruct.new(v[1])})}
    end

    def fields
      @fields
    end

    def aws_credentials
      {:access_key_id => self.access_key_id, :secret_access_key => self.secret_access_key}
    end
  end
end
