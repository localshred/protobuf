require 'resolv'
require 'protobuf/rpc/servers/zmq/util'

module Protobuf
  module Rpc
    module Zmq
      class Broker
        include ::Protobuf::Rpc::Zmq::Util
        attr_reader :frontend, :backend, :poller, :context

        ## 
        # Constructor
        #
        def initialize(opts={})
          @context = ::ZMQ::Context.new
          @frontend = setup_frontend(opts)
          @backend = setup_backend(opts)
          @poller = setup_poller
        end

        ##
        # Instance Methods
        #
        def poll
          poller.poll(1000)
          poller.readables.each do |socket|
            case socket
            when frontend then
              move_to(backend, socket)
            when backend then
              move_to(frontend, socket)
            end
          end
        end

        def teardown
          frontend.close
          backend.close
          context.terminate
        end

        private

          def move_to(frontend_or_backend, socket)
            more_data = true

            while more_data do
              socket.recv_string(data = "")
              more_data = socket.more_parts?
              more_data_flag = (more_data ? ::ZMQ::SNDMORE : 0)
              frontend_or_backend.send_string(data, more_data_flag)
            end
          end

          def setup_backend(opts={})
            dealer_options = opts.merge(:port => opts.fetch(:port, 9399) + 1)
            host = dealer_options.fetch(:host, "127.0.0.1")
            port = dealer_options.fetch(:port, 9400)
            protocol = dealer_options.fetch(:protocol, "tcp")

            zmq_backend = context.socket(::ZMQ::DEALER)
            zmq_error_check(zmq_backend.bind("#{protocol}://#{resolve_ip(host)}:#{port}"))
            zmq_backend
          end

          def setup_frontend(opts={})
            host = opts.fetch(:host, "127.0.0.1")
            port = opts.fetch(:port, 9399)
            protocol = opts.fetch(:protocol, "tcp")

            zmq_frontend = context.socket(::ZMQ::ROUTER)
            zmq_error_check(zmq_frontend.bind("#{protocol}://#{resolve_ip(host)}:#{port}"))
            zmq_frontend
          end

          def setup_poller
            zmq_poller = ::ZMQ::Poller.new
            zmq_poller.register(frontend, ::ZMQ::POLLIN)
            zmq_poller.register(backend, ::ZMQ::POLLIN)
            zmq_poller
          end
      end
    end
  end
end
