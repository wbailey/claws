module Claws
  module Command
    class Version
      def self.exec
        puts Claws::VERSION
        exit 0
      end
    end
  end
end
