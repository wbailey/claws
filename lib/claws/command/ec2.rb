module Claws
  module Command
    class EC2
      def self.exec(options)
        begin
          config = Claws::Configuration.new( options.config_file )
        rescue Claws::ConfigurationError => e
          puts e.message
          puts 'Use the --init option to create a configuration file.'
          exit 1
        rescue Exception => e
          puts e.message
          exit 1
        end

        Claws::Collection::EC2.connect( config.aws )

        begin
          instances = Claws::Collection::EC2.get
        rescue Exception => e
          puts e.message
        end

        Claws::Report::EC2.new( config, instances ).run

        if options.connect
          if instances.size == 1
            puts
            selection = 0
          elsif options.selection
            puts
            selection = options.selection
          else
            print "Select server (enter q to quit): "
            selection = gets.chomp
            exit 0 if selection.match(/^q.*/i)
          end

          puts 'connecting to server...'

          system "ssh #{config.aws_user}@#{instances[selection.to_i].dns_name}"
        end
      end
    end
  end
end
