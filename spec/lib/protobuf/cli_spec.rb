require 'spec_helper'
require 'protobuf/cli'

describe ::Protobuf::CLI do

	let(:app_file) do
		File.expand_path('../../../support/test_app_file.rb', __FILE__)
	end

	before do
		::Protobuf::Rpc::SocketRunner.stub(:run)
		::Protobuf::Rpc::ZmqRunner.stub(:run)
		::Protobuf::Rpc::EventedRunner.stub(:run)
	end

	describe '#start' do
		let(:base_args) { [ 'start', app_file ] }
		let(:test_args) { [] }
		let(:args) { base_args + test_args }

		context 'host option' do
			let(:test_args) { [ '--host=123.123.123.123' ] }

			it 'sends the host option to the runner' do
				::Protobuf::Rpc::SocketRunner.should_receive(:run) do |options|
					options.host.should eq '123.123.123.123'
				end
				described_class.start(args)
			end
		end

		context 'port option' do
			let(:test_args) { [ '--port=12345' ] }

			it 'sends the port option to the runner' do
				::Protobuf::Rpc::SocketRunner.should_receive(:run) do |options|
					options.port.should eq 12345
				end
				described_class.start(args)
			end
		end

		context 'backlog option' do
			let(:test_args) { [ '--backlog=500' ] }

			it 'sends the backlog option to the runner' do
				::Protobuf::Rpc::SocketRunner.should_receive(:run) do |options|
					options.backlog.should eq 500
				end
				described_class.start(args)
			end
		end

		context 'threshold option' do
			let(:test_args) { [ '--threshold=500' ] }

			it 'sends the backlog option to the runner' do
				::Protobuf::Rpc::SocketRunner.should_receive(:run) do |options|
					options.threshold.should eq 500
				end
				described_class.start(args)
			end
		end

		context 'log options' do
			let(:test_args) { [ '--log=mylog.log', '--level=0' ] }

			it 'sends the log file and level options to the runner' do
				::Protobuf::Logger.should_receive(:configure) do |options|
					options[:file].should eq 'mylog.log'
					options[:level].should eq 0
				end
				described_class.start(args)
			end

			context 'when debugging' do
				let(:test_args) { [ '--level=3', '--debug' ] }

				it 'overrides the log-level to DEBUG' do
					::Protobuf::Logger.should_receive(:configure) do |options|
						options[:level].should eq ::Logger::DEBUG
					end
					described_class.start(args)
				end
			end
		end

		context 'gc options' do

			context 'when gc options are not present' do
				let(:test_args) { [] }

				it 'sets both request and serialization pausing to false' do
					described_class.start(args)
					::Protobuf.gc_pause_server_request.should be_false
					::Protobuf.gc_pause_server_serialization.should be_false
				end
			end

			context 'request pausing' do
				let(:test_args) { [ '--gc_pause_request' ] }

				it 'sets the configuration option to GC pause server request' do
					described_class.start(args)
					::Protobuf.gc_pause_server_request.should be_true
				end
			end

			context 'serialization pausing' do
				let(:test_args) { [ '--gc_pause_serialization' ] }

				it 'sets the configuration option to GC pause server serializations' do
					described_class.start(args)
					::Protobuf.gc_pause_server_serialization.should be_true
				end
			end
		end

		context 'run modes' do

			context 'socket' do
				let(:test_args) { [ '--socket' ] }

				before do
					::Protobuf::Rpc::EventedRunner.should_not_receive(:run)
					::Protobuf::Rpc::ZmqRunner.should_not_receive(:run)
				end

				it 'is activated by the --socket switch' do
					::Protobuf::Rpc::SocketRunner.should_receive(:run)
					described_class.start(args)
				end

				it 'configures the connector type to be socket' do
          load "protobuf/socket.rb"
					::Protobuf.connector_type.should == :socket
				end
			end

			context 'evented' do
				let(:test_args) { [ '--evented' ] }

				before do
					::Protobuf::Rpc::SocketRunner.should_not_receive(:run)
					::Protobuf::Rpc::ZmqRunner.should_not_receive(:run)
				end

				it 'is activated by the --evented switch' do
					::Protobuf::Rpc::EventedRunner.should_receive(:run)
					described_class.start(args)
				end

				it 'configures the connector type to be evented' do
          load "protobuf/evented.rb"
					::Protobuf.connector_type.should == :evented
				end
			end

			context 'zmq' do
				let(:test_args) { [ '--zmq' ] }

				before do
					::Protobuf::Rpc::SocketRunner.should_not_receive(:run)
					::Protobuf::Rpc::EventedRunner.should_not_receive(:run)
				end

				it 'is activated by the --zmq switch' do
					::Protobuf::Rpc::ZmqRunner.should_receive(:run)
					described_class.start(args)
				end

				it 'configures the connector type to be zmq' do
          load "protobuf/zmq.rb"
					::Protobuf.connector_type.should == :zmq
				end
			end

		end

	end

end
