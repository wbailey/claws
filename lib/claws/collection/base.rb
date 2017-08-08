require 'aws-sdk'

module Claws
  module Collection
    class Base
      attr_accessor :config

      def initialize(config)
        self.config = config
        Aws.config.update(config.aws)
      end
    end
  end
end
