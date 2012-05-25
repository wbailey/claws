require 'spec_helper'

describe Claws::Command::Initialize do
  subject { Claws::Command::Initialize }

  let(:config) { 'test/.test.yml' }

  it 'works' do
    File.should_receive(:join).and_return(config)
    subject.should_receive(:puts)

    fh = double( File, :write => true )

    File.should_receive(:open).with(config, 'w').and_return(fh)
    subject.should_receive(:puts)

    subject.exec
  end
end
