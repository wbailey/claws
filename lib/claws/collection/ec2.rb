require 'aws-sdk'
require 'claws/collection/base'
require 'claws/presenter/ec2'

module Claws
  module Collection
    class EC2 < Claws::Collection::Base
      def get # get(filters = {})
        collection = []

        Aws::EC2.new.regions.each do |region|
          if config.ec2.regions
            next unless config.ec2.regions.include?(region.name)
          end

          region.instances.each do |instance|
            collection << Claws::EC2::Presenter.new(instance, region: region.name)
          end
        end

        collection
      end
    end
  end
end
