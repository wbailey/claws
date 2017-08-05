module Claws
  class Capistrano
    attr_accessor :home

    def initialize(home = nil)
      home ||= File.join('config', 'deploy')
      home
    end

    def all_host_roles
      @all_roles ||= begin
        roles = {}

        Dir.glob(File.join(home, '**/*.rb')).each do |f|
          environment = File.basename(f)[0..-4]
          roles[environment.to_sym] = get_roles(environment)
        end

        roles
      end
    end

    def roles(host)
      all_host_roles.each do |_, hh|
        hh.each do |k, v|
          return v if k == host
        end
      end
    end

    private

    def get_roles(environment)
      role_records = File.readlines(File.join(home, "#{environment}.rb")).select { |r| r.match(/^role/) }

      # At this point we have an array of strings with:
      #
      # [
      #   "role :app, \"ec2-263-56-231-91.compute-1.amazonaws.com\", 'ec2-263-23-118-57.compute-1.amazonaws.com'",
      #   "role :web, \"ec2-263-56-231-91.compute-1.amazonaws.com\", 'ec2-263-23-118-57.compute-1.amazonaws.com', \"ec2-23-20-43-198.compute-1.amazonaws.com\"",
      # ]
      #
      # and we want to convert that to:
      #
      # {
      #   'ec2-263-56-231-91.compute-1.amazonaws.com' => ["app", "web"],
      #   'ec2-263-23-118-57.compute-1.amazonaws.com' => ["app", "web"],
      #   'ec2-23-20-43-198.compute-1.amazonaws.com' => ["web"],
      # }

      roles = Hash.new { |h, k| h[k] = [] }

      role_records.each do |record|
        role, *hosts = record.split(',').map { |v| v.strip.chomp.gsub(/"|'/, '') }

        hosts.each do |host|
          roles[host] << role.split(':')[1]
        end
      end

      roles
    end
  end
end
