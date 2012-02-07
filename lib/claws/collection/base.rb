require 'aws-sdk'

module Claws
  module Collection
    class Base
      def self.connect(credentials)
        AWS.config(credentials)
        AWS.start_memoizing
      end
    end
  end
end
