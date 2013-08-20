require 'protobuf/generators/file_generator'

module Protobuf
  class CodeGenerator

    CodeGeneratorFatalError = Class.new(RuntimeError)

    def self.fatal(message)
      raise CodeGeneratorFatalError, message
    end

    def self.print_tag_warning_suppress
      STDERR.puts "Suppress tag warning output with PB_NO_TAG_WARNINGS=1."
      def self.print_tag_warning_suppress; end
    end

    def self.warn(message)
      STDERR.puts("[WARN] #{message}")
    end

    def initialize(request_bytes)
      @request = ::Google::Protobuf::Compiler::CodeGeneratorRequest.new
      @request.parse_from_string(request_bytes)
      @generated_files = []
    end

    def generate_file(file_descriptor)
      file_generator = ::Protobuf::Generators::FileGenerator.new(file_descriptor)
      @generated_files << file_generator.generate_output_file
    end

    def response_bytes
      @request.proto_file.each do |file_descriptor|
        generate_file(file_descriptor)
      end

      response = ::Google::Protobuf::Compiler::CodeGeneratorResponse.new(:file => @generated_files)
      return response.serialize_to_string
    end

  end
end

