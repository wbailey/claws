require 'aws-sdk'

module Claws
  module Collection
    class Base
      def self.connect(credentials)
        AWS.config(credentials)
        AWS.start_memoizing
      end

      def self.build
        self.connect
        collection = []
        yield(collection)
        collection
      end
    end
  end
end
