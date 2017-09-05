require 'spec_helper'
require 'aws-sdk'
require 'claws/collection/ec2'

# rubocop:disable all
describe Claws::Collection::EC2 do
  subject { Claws::Collection::EC2 }

  let(:credentials) do
    {
      access_key_id: 'asdf',
      secret_access_key: 'qwer'
    }
  end

  let(:reservations) do
    [
      double(
        'Aws::EC2::Types::Reservation',
        groups: [],
        instances: [double('Aws::EC2::Instance'), double('Aws::EC2::Instance')],
        owner_id: '182832195110',
        requester_id: nil,
        reservation_id: 'r-627ed8ba'
      ),
      double(
        'Aws::EC2::Types::Reservation',
        groups: [],
        instances: [double('Aws::EC2::Instance'), double('Aws::EC2::Instance')],
        owner_id: '182832195110',
        requester_id: nil,
        reservation_id: 'r-627ed8bb'
      )
    ]
  end

  # context 'gets all instances in regions' do
  #   it 'not defined in configuration' do
  #     allow(Aws).to receive_message_chain(:config, :update).with(credentials).and_return(true)

  #     expect(Aws::EC2::Client).to receive(:new).with(credentials).and_return(
  #       double('Aws::EC2::Client')
  #     )

  #     config = double(
  #       'Claws::Configuration',
  #       aws: credentials,
  #       ec2: OpenStruct.new(regions: nil)
  #     )

  #     expect(subject.new(config).get.size).to eq(4)
  #   end

  #   it 'defined in configuation' do
  #     allow(Aws).to receive_message_chain(:config, :update).with(credentials).and_return(true)

  #     allow(Aws::EC2).to receive(:new).and_return(
  #       double('Aws::EC2::RegionsCollection', regions: regions)
  #     )

  #     config = double(
  #       'Claws::Configuration',
  #       aws: credentials,
  #       ec2: OpenStruct.new(regions: %w[us-east-1 eu-east-1])
  #     )

  #     expect(subject.new(config).get.size).to eq(4)
  #   end
  # end

  it 'gets all instances for an account' do
    client = double('Aws::EC2::Client', describe_instances: reservations)

    # expect(subject).to receive(:new) do
      expect('Aws::EC2::Client').to receive(:new).with(credentials).and_return(client)
    # end

    # expect(subject).to receive(:get) # do
      # expect(client).to receive(:describe_instances) # .and_return(reservations)
    # end

    config = double(
      'Claws::Configuration',
      aws: credentials,
      ec2: OpenStruct.new(regions: %w[us-east-1])
    )

    expect(subject.new(config).get.size).to eq(2)
  end
end
