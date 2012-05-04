require 'aws-sdk'
require 'claws/collection/base'
require 'claws/ec2/presenter'

module Claws
  module Collection
    class EC2 < Claws::Collection::Base
      def self.get(filters = {})
        collection = []
        AWS::EC2.new.instances.each do |instance|
          collection << Claws::EC2::Presenter.new(instance)
        end
        collection
      end
    end
  end
end
