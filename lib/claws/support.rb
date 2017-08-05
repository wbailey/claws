# Wish this was part of the ruby core
module Claws
  module Support
    def try(meth, *args, &block)
      respond_to?(meth) ? send(meth, *args, &block) : nil
    end
  end
end

class Array
  include Claws::Support
end
