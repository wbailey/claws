module Claws
  module Support
    def try(meth, *args, &block)
      self.respond_to?(meth) ? self.send(meth, *args, &block) : nil
    end
  end
end

class Array
  include Claws::Support
end
