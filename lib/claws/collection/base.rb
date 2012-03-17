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

module Claws
  module Support
    def try(meth, *args, &block)
      self.respond_to?(meth) ? self.send(meth, *args, &block) : nil
    end
  end
end

class Array
  include Claws::Support
end
