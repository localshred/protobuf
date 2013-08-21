require 'spec_helper'

require 'protobuf/code_generator'

describe ::Protobuf::CodeGenerator do

  # Some constants to shorten things up
  DESCRIPTOR = ::Google::Protobuf
  COMPILER = ::Google::Protobuf::Compiler

  describe '#response_bytes' do
    let(:input_file1) { DESCRIPTOR::FileDescriptorProto.new(:name => 'test/foo.proto') }
    let(:input_file2) { DESCRIPTOR::FileDescriptorProto.new(:name => 'test/bar.proto') }

    let(:output_file1) { COMPILER::CodeGeneratorResponse::File.new(:name => 'test/foo.pb.rb') }
    let(:output_file2) { COMPILER::CodeGeneratorResponse::File.new(:name => 'test/bar.pb.rb') }

    let(:file_generator1) { mock('file generator 1', :generate_output_file => output_file1) }
    let(:file_generator2) { mock('file generator 2', :generate_output_file => output_file2) }

    let(:request_bytes) do
      COMPILER::CodeGeneratorRequest.encode(:proto_file => [ input_file1, input_file2 ])
    end

    let(:expected_response_bytes) do
      COMPILER::CodeGeneratorResponse.encode(:file => [ output_file1, output_file2 ])
    end

    before do
      ::Protobuf::Generators::FileGenerator.should_receive(:new).with(input_file1).and_return(file_generator1)
      ::Protobuf::Generators::FileGenerator.should_receive(:new).with(input_file2).and_return(file_generator2)
    end

    it 'returns the serialized CodeGeneratorResponse which contains the generated file contents' do
      generator = described_class.new(request_bytes)
      generator.response_bytes.should eq expected_response_bytes
    end
  end

  context 'class-level printing methods' do
    describe '.fatal' do
      it 'raises a CodeGeneratorFatalError error' do
        expect {
          described_class.fatal("something is wrong")
        }.to raise_error(
          ::Protobuf::CodeGenerator::CodeGeneratorFatalError,
          "something is wrong"
        )
      end
    end

    describe '.warn' do
      it 'prints a warning to stderr' do
        STDERR.should_receive(:puts).with("[WARN] a warning")
        described_class.warn("a warning")
      end
    end
  end

end
