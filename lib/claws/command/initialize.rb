require 'yaml'

module Claws
  module Command
    class Initialize
      def self.exec
        h = {
          'aws_user' => nil,
          'capistrano_home' => nil,
          'access_key_id' => nil,
          'secret_access_key' => nil,
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
          }
        }

        conf = File.join(ENV['HOME'], '.claws.yml')
        puts "Creating configuration file: #{conf}"
        puts '...'
        File.open(conf, 'w').write(h.to_yaml)
        puts 'Complete!'
      end
    end
  end
end
