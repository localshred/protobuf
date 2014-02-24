module Protobuf
  module Rpc
    class Env < Hash
      # Creates an accessor that simply sets and reads a key in the hash:
      #
      #   class Config < Hash
      #     hash_accessor :app
      #   end
      #
      #   config = Config.new
      #   config.app = Foo
      #   config[:app] #=> Foo
      #
      #   config[:app] = Bar
      #   config.app #=> Bar
      #
      def self.hash_accessor(*names) #:nodoc:
        names.each do |name|
          class_eval <<-METHOD, __FILE__, __LINE__ + 1
            def #{name}
              self['#{name}']
            end

            def #{name}=(value)
              self['#{name}'] = value
            end

            def #{name}?
              ! self['#{name}'].nil?
            end
          METHOD
        end
      end

      # TODO: Add extra info about the environment (i.e. variables) and other
      # information that might be useful
      hash_accessor :client_host,
                    :encoded_request,
                    :encoded_response,
                    :method_name,
                    :request,
                    :request_type,
                    :response,
                    :response_type,
                    :rpc_method,
                    :rpc_service,
                    :service_name,
                    :worker_id

      def initialize(options={})
        merge!(options)

        self['worker_id'] = ::Thread.current.object_id.to_s(16)
      end
    end
  end
end
