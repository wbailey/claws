require 'claws/capistrano'
require 'claws/support'

module Claws
  module EC2
    class Presenter
      attr_writer :roles

      def initialize(instance, options = {})
        @ec2 = instance.extend(Claws::Support)
        @roles = options[:roles] || []
        @region = options[:region]
        freeze
      end

      def region
        @region || 'N/A'
      end

      def roles
        @roles.empty? ? 'N/A' : @roles.join(', ')
      end

      def tags
        @ec2.try(:tags) ? @ec2.tags.select {|k,v| [k,v] unless k.downcase == 'name'}.map{|k,v| "#{k}: #{v}"}.join(', ') : 'N/A'
      end

      def security_groups
        @ec2.try(:security_groups) ? @ec2.security_groups.map {|sg| "#{sg.id}: #{sg.name}"}.join(', ') : 'N/A'
      end

      def method_missing(meth)
        case meth
        when :name
          @ec2.send(:tags)['Name'] || 'N/A'
        when @ec2.try(:tags) && @ec2.tags.has_key?(meth)
          @ec2.tags[meth] || 'N/A'
        else
          begin
            @ec2.send(meth)
          rescue Exception
            'N/A'
          end
        end
      end
    end
  end
end
