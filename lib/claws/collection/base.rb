require 'aws-sdk'

module Claws
  module Collection
    class Base
      def self.connect(credentials)
        AWS.config(credentials)
        AWS.start_memoizing
      end

      # Seems unnecessary
      def self.build
        collection = []
        yield(collection)
        collection
      end
    end
  end
end
