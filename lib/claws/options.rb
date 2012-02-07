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

        opts.on('-s', '--status', 'display host status only and exit') do
          options.connect = false
        end
      end.parse!

      options
    end
  end
end
