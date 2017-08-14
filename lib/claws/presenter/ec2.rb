require 'claws/capistrano'
require 'claws/support'

module Claws
  module EC2
    class Presenter
      attr_writer :roles

      def initialize(instance, options = {})
        @ec2 = instance # .extend(Claws::Support)
        @roles = options[:roles] || []
        @region = options[:region]
        freeze
      end

      def state
        @ec2.state.name
      end

      def roles
        @roles.empty? ? 'N/A' : @roles.join(', ')
      end

      def tags
        if @ec2&.tags
          @ec2.tags.select { |t| t unless t.key.casecmp('name').zero? }.map { |t| "#{t.key}: #{t.value}" }.join(', ')
        else
          'N/A'
        end
      end

      def security_groups
        @ec2&.security_groups ? @ec2.security_groups.map { |sg| "#{sg.group_id}: #{sg.group_name}" }.join(', ') : 'N/A'
      end

      def method_missing(meth)
        case meth
        when :name
          @ec2.tags.find { |t| t.key.eql?('Name') }.value || 'N/A'
        when val = @ec2.tags.find { |t| t.key.eql?(meth) }
          val
        else
          begin
            @ec2.send(meth)
          rescue NoMethodError # Exception
            'N/A'
          end
        end
      end
    end
  end
end
