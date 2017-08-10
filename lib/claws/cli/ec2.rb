module Claws
  module CLI
    class EC2
      attr_accessor :instances, :config, :options

      def initialize(instances, config, options)
        self.instances = instances
        self.config = config
        self.options = options
      end

      def run
        if instances.size == 1
          puts
          selection = 0
        elsif options.selection
          puts
          selection = options.selection
        else
          print 'Select server (enter q to quit): '
          selection = gets.chomp
          exit 0 if selection.match?(/^q.*/i)
        end

        puts 'connecting to server...'

        ssh(selection)
      end

      private

      def ssh(selection)
        identity = config.ssh.identity.nil? ? '' : "-i #{config.ssh.identity}"

        instance = instances[selection.to_i]

        hostname = instance.vpc? ? instance.private_ip_address : instance.dns_name

        system "ssh #{identity} #{config.ssh.user}@#{instance.public_dns_name}"
      end
    end
  end
end
