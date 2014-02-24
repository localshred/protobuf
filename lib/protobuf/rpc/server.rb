require 'protobuf'
require 'protobuf/rpc/rpc.pb'
require 'protobuf/rpc/buffer'
require 'protobuf/rpc/env'
require 'protobuf/rpc/error'
require 'protobuf/rpc/middleware'
require 'protobuf/rpc/service_dispatcher'

require 'protobuf/rpc/log_subscriber'

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
        # Create an env object that holds different parts of the environment and
        # is available to all of the middlewares
        env = Env.new('encoded_request' => request_data)

        # Invoke the middleware stack, the last of which is the service dispatcher
        ::ActiveSupport::Notifications.instrument("handle_request.protobuf") do |payload|
          env = Rpc.middleware.call(env)
          payload.merge!(env)
        end

        env.encoded_response
      end
    end
  end
end
