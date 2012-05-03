require 'claws/collection/base'
require 'aws-sdk'

module Claws
  module Collection
    class EC2 < Claws::Collection::Base
      def self.get(filters = {})
        collection = []
        AWS::EC2.new.instances.each do |instance|
          collection << instance
        end
        collection
      end
    end
  end
end
