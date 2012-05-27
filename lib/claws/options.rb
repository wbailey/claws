require 'ostruct'

module Claws
  class Options
    def self.parse
      options = OpenStruct.new(
        {
          :config_file => nil,
          :connect => true,
          :initialize => false,
          :version => false,
          :selection => nil,
          :source => 'ec2',
        }
      )

      OptionParser.new do |opts|
        opts.banner = 'Usage: claws [options]'

        opts.on('-d', '--display-only', 'Display host status only and exit') do
          options.connect = false
        end

        opts.on('-c', '--choice N', Float, 'Enter the number of the host to automatically connect to') do |n|
          options.selection = n.to_i
        end

        opts.on('-i', '--init', 'Install the default configuration file for the application') do
          options.initialize = true
        end

        opts.on('-s', '--source S', String, 'define the AWS source - default is ec2') do |source|
          options.source = source
        end

        opts.on('-v', '--version', 'Display the version number and exit') do
          options.version = true
        end
      end.parse!

      unless ARGV.empty?
        options.environment = ARGV.shift
        options.role = ARGV.shift
      end

      options
    end
  end
end
