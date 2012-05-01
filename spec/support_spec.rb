require 'spec_helper'
require 'claws/support'

describe Claws::Support do
  subject { Array.new }

  describe '#try' do
    it 'handles undefined methods sanely' do
      subject.try('asdf').should be_nil
    end

    it 'performs defined methods' do
      subject.try('push', 2)
      subject.should == [2]
    end
  end
end
