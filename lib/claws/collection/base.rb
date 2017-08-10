require 'aws-sdk'

module Claws
  module Collection
    class Base
      attr_accessor :config, :credentials, :client

      def initialize(config)
        self.config = config

        self.credentials = Aws::Credentials.new(config.aws['access_key_id'], config.aws['secret_access_key'])
      end
    end
  end
end
