require 'yaml'

module Claws
  module Command
    class Initialize
      def self.exec
        h = {
          'capistrano' => {
            'home' => nil,
          },
          'ssh' => {
            'user' => nil,
            'identity' => nil,
          },
          'aws' => {
            'access_key_id' => nil,
            'secret_access_key' => nil,
          },
          'ec2' => {
            'fields' => {
              'id' => {
                'width' => 10,
                'title' => 'ID',
              },
              'name' => {
                'width' => 20,
                'title' => 'Name',
              },
              'status' => {
                'width' => 8,
                'title' => 'Status',
              },
              'dns_name' => {
                'width' => 42,
                'title' => 'DNS Name',
              },
              'instance_type' => {
                'width' => 13,
                'title' => 'Instance Type',
              },
              'public_ip_address' => {
                'width' => 16,
                'title' => 'Public IP',
              },
              'private_ip_address' => {
                'width' => 16,
                'title' => 'Private IP',
              },
              'tags' => {
                'width' => 30,
                'title' => 'tags',
              },
            },
          }
        }

        conf = File.join(ENV['HOME'], '.claws.yml')

        if File.exists?(conf)
          puts "Configuration file #{conf} exists!  Either remove or modify contents."
          exit 1
        else
          puts "Creating configuration file: #{conf}\n..."
          File.open(conf, 'w').write(h.to_yaml)
          puts "Complete!\nPlease enter your access key id and secret access key in #{conf}"
          exit 0
        end
      end
    end
  end
end
