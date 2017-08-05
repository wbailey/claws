require 'command_line_reporter'

module Claws
  module Report
    class EC2
      attr_accessor :config, :instances

      include CommandLineReporter

      def initialize(config, instances)
        self.config = config
        self.instances = instances
      end

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/MethodLength
      def run
        # rubocop:disable Metrics/BlockLength
        table border: true do
          row header: true do
            column 'Choice', width: 6, color: 'blue', bold: true, align: 'right'

            config.ec2.fields.each do |field, properties|
              text = properties['title'] || field
              width = properties['width'] || nil
              column text, width: width, color: 'blue', bold: true
            end
          end

          choice = 0

          instances.each do |i|
            color = case i.status
                    when :running
                      'green'
                    when :stopped
                      'red'
                    else
                      'white'
                    end

            row color: 'white' do
              column choice

              config.ec2.fields.each do |field|
                props = field == 'status' ? { color: color } : {}
                field_alias = field == 'id' ? 'instance_id' : field # This makes 1.8.7 not spit out a warning
                column i.send(field_alias), props
              end
            end

            choice += 1
          end
        end
      end
    end
  end
end
