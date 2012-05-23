require 'spec_helper'

describe Claws::Command::EC2 do
  subject { Claws::Command::EC2 }

  describe '#exec' do
    context 'configuration files' do
      let(:options) { OpenStruct.new( { :config_file => '/doesnotexist', } ) }

      it 'missing files' do
        subject.should_receive(:puts).twice

        expect {
          subject.exec options
        }.should raise_exception SystemExit
      end

      it 'invalid file' do
        YAML.should_receive(:load_file).and_raise(Exception)

        subject.should_receive(:puts).twice

        expect {
          subject.exec options
        }.should raise_exception SystemExit
      end
    end

    context 'valid config file' do
      let(:options) { OpenStruct.new( { :config_file => nil, } ) }
      context 'instance collections' do

        it 'retrieves' do
          Claws::Collection::EC2.should_receive(:get).and_return([])

          capture_stdout {
            subject.exec options
          }
        end

        it 'handles errors retrieving' do
          Claws::Collection::EC2.should_receive(:get).and_raise(Exception)
          subject.should_receive(:puts).once

          expect {
            subject.exec options
          }.should raise_exception
        end
      end

      it 'performs report' do
        expect {
          capture_stdout {
            subject.exec options
          }
        }.should_not raise_exception
      end
    end

    context 'connect options' do
      let(:options) { OpenStruct.new( { :config_file => nil, :connect => true } ) }

      before :each do
        Claws::Configuration.stub(:new).and_return(
          OpenStruct.new(
            {
              :ssh => OpenStruct.new(
                { :user => 'test' }
              ),
              :ec2 => OpenStruct.new(
                :fields => {
                  :id => {
                    :width => 10,
                    :title => 'ID',
                  }
                }
              )
            }
          )
        )
      end

      context 'single instance' do
        let(:instances) do
          [
            double(AWS::EC2::Instance, :id => 'test', :status => 'running', :dns_name => 'test.com')
          ]
        end

        it 'automatically connects to the server' do
          Claws::Collection::EC2.should_receive(:connect).and_return(true)
          Claws::Collection::EC2.should_receive(:get).and_return(instances)

          subject.should_receive(:puts).twice
          subject.should_receive(:system).with('ssh test@test.com').and_return(0)

          capture_stdout {
            subject.exec options
          }
        end
      end

      context 'multiple instances' do
        let(:instances) do
          [
            double(AWS::EC2::Instance, :id => 'test1', :status => 'running', :dns_name => 'test1.com'),
            double(AWS::EC2::Instance, :id => 'test2', :status => 'running', :dns_name => 'test2.com'),
            double(AWS::EC2::Instance, :id => 'test3', :status => 'running', :dns_name => 'test3.com'),
          ]
        end

        it 'handles user inputed selection from the command line' do
          Claws::Collection::EC2.should_receive(:connect).and_return(true)
          Claws::Collection::EC2.should_receive(:get).and_return(instances)

          subject.should_receive(:puts).twice
          subject.should_receive(:system).with('ssh test@test2.com').and_return(0)

          capture_stdout {
            subject.exec OpenStruct.new( {:selection => 1, :config_file => nil, :connect => true} )
          }

        end

        it 'presents a selection and connects to the server' do
          Claws::Collection::EC2.should_receive(:connect).and_return(true)
          Claws::Collection::EC2.should_receive(:get).and_return(instances)

          subject.should_receive(:gets).and_return('1\n')
          subject.should_receive(:puts).once
          subject.should_receive(:system).with('ssh test@test2.com').and_return(0)

          capture_stdout {
            subject.exec options
          }
        end
      end
    end
  end
end
