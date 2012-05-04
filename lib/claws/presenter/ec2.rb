require 'claws/capistrano'
require 'claws/support'

module Claws
  module EC2
    class Presenter
      attr_writer :roles

      def initialize(instance, has_roles = [])
        @ec2 = instance.extend(Claws::Support)
        @roles = has_roles
        freeze
      end

      def roles
        @roles.empty? ? 'N/A' : @roles.join(', ')
      end

      def tags
        @ec2.try(:tags) ? @ec2.tags.map {|t| "#{t.key}: #{t.value}"}.join(', ') : 'N/A'
      end

      def security_groups
        @ec2.try(:security_groups) ? @ec2.security_groups.map {|sg| "#{sg.id}: #{sg.name}"}.join(', ') : 'N/A'
      end

      def method_missing(meth)
        case meth
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
