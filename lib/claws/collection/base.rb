require 'aws-sdk'

module Claws
  module Collection
    class Base
      attr_accessor :config

      def initialize(config)
        self.config = config
        Aws.config(config.aws)
        Aws.start_memoizing
      end
    end
  end
end
