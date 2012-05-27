require 'aws-sdk'

module Claws
  module Collection
    class Base
      attr_accessor :config

      def initialize( config )
        self.config = config
        AWS.config(config.aws)
        AWS.start_memoizing
      end
    end
  end
end
