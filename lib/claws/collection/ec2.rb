require 'aws-sdk'
require 'claws/collection/base'
require 'claws/presenter/ec2'

module Claws
  module Collection
    class EC2 < Claws::Collection::Base
      def initialize(config)
        super(config)
        self.client = Aws::EC2::Client.new(credentials: credentials)
      end

      def get # get(filters = {})
        collection = []

        client.describe_instances.reservations.each do |reservation|
          reservation.instances.each do |instance|
            collection << Claws::EC2::Presenter.new(instance)
          end
        end

        collection
      end
    end
  end
end
