require 'ostruct'

module Claws
  class Options
    def self.parse
      options = OpenStruct.new(
        {
          :connect => true,
          :source => 'ec2',
          :choice => nil,
        }
      )

      OptionParser.new do |opts|
        opts.banner = "Usage: script/aws [options] [environment] [role]"

        opts.on('-d', '--display-only', 'display host information only and exit') do
          options.connect = false
        end

        opts.on('-c', '--choice N', Float, 'enter the identity number of the host to automatically connect to') do |n|
          options.choice = n.to_i
        end

        opts.on('-s', '--source', 'define the AWS source - default is ec2') do
          options.source = 'elb'
          options.connect = false
        end
      end.parse!

      options.environment = ARGV.shift
      options.role = ARGV.shift

      options
    end
  end
end
