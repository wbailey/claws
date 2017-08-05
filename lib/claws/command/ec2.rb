module Claws
  module Command
    class EC2
      def self.exec(options)
        config = Claws::Configuration.new(options.config_file)

        instances = Claws::Collection::EC2.new(config).get

        Claws::Report::EC2.new(config, instances).run

        Claws::CLI::EC2.new(instances, config, options).run if options.connect
      end
    end
  end
end
