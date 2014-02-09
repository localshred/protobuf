require 'protobuf'
require 'protobuf/logger'
require 'protobuf/rpc/rpc.pb'
require 'protobuf/rpc/buffer'
require 'protobuf/rpc/error'
require 'protobuf/rpc/stat'
require 'protobuf/rpc/service_dispatcher'

module Protobuf
  module Rpc
    module Server
      def gc_pause
        ::GC.disable if ::Protobuf.gc_pause_server_request?

        yield

        ::GC.enable if ::Protobuf.gc_pause_server_request?
      end

      # Invoke the service method dictated by the proto wrapper request object
      #
      def handle_request(request_data)
        log_debug { sign_message("Handling request") }

        initialize_stats!
        stats.request_size = request_data.size

        request = decode_request_data(request_data)
        stats.client = request.caller

        response_data = dispatch_request(request)
      rescue => error
        log_exception(error)
        response_data = handle_error(error)
      ensure
        encoded_response = encode_response_data(response_data)
        stats.stop

        # Log the response stats
        log_info { stats.to_s }

        encoded_response
      end

      def log_signature
        @_log_signature ||= "[server-#{self.class.name}]"
      end

    private

      # Decode the incoming request object into our expected request object
      #
      def decode_request_data(data)
        log_debug { sign_message("Decoding request: #{data}") }

        Socketrpc::Request.decode(data)
      rescue => error
        exception = BadRequestData.new("Unable to decode request: #{error.message}")
        log_error { exception.message }
        raise exception
      end

      # Dispatch the request to the service
      #
      def dispatch_request(request)
        dispatcher = ServiceDispatcher.new(request)
        stats.dispatcher = dispatcher

        # Log the request stats
        log_info { stats.to_s }

        dispatcher.invoke!

        if dispatcher.success?
          Socketrpc::Response.new(:response_proto => response_data)
        else
          handle_error(dispatcher.error)
        end
      end

      # Encode the response wrapper to return to the client
      #
      def encode_response_data(response)
        log_debug { sign_message("Encoding response: #{response.inspect}") }

        encoded_response = response.encode
      rescue => error
        log_exception(error)
        encoded_response = handle_error(error).encode
      ensure
        stats.response_size = encoded_response.size
        encoded_response
      end

      # Embed exceptions in a response wrapper
      #
      def handle_error(error)
        log_debug { sign_message("handle_error: #{error.inspect}") }

        if error.respond_to?(:to_response)
          error.to_response
        else
          PbError.new(error.message).to_response
        end
      end

      # Initialize a new stats tracker
      #
      # NOTE: This has to be reinitialized with each request and can't be
      # memoized since servers aren't reinitialized with each request
      #
      def initialize_stats!
        @_stats = Stat.new(:SERVER)
      end

      def stats
        @_stats
      end
    end
  end
end
