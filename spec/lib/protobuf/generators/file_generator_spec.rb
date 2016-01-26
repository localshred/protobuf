require 'spec_helper'

require 'protobuf/generators/file_generator'

RSpec.describe ::Protobuf::Generators::FileGenerator do

  let(:base_descriptor_fields) { { :name => 'test/foo.proto' } }
  let(:descriptor_fields) { base_descriptor_fields }
  let(:file_descriptor) { ::Google::Protobuf::FileDescriptorProto.new(descriptor_fields) }

  subject { described_class.new(file_descriptor) }
  specify { expect(subject.file_name).to eq('test/foo.pb.rb') }

  describe '#print_import_requires' do
    let(:descriptor_fields) do
      base_descriptor_fields.merge(
        :dependency => [
          'test/bar.proto',
          'test/baz.proto',
        ],
      )
    end

    it 'prints a ruby require for each dependency' do
      expect(subject).to receive(:print_require).with('test/bar.pb')
      expect(subject).to receive(:print_require).with('test/baz.pb')
      subject.print_import_requires
    end

  end

  describe '#compile' do
    it 'generates the file contents' do
      subject.compile
      expect(subject.to_s).to eq <<EOF
# encoding: utf-8

##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'

EOF
end

    context 'with extended messages' do
      let(:descriptor_fields) do
        base_descriptor_fields.merge(
          :package => 'test.pkg.file_generator_spec',
          :extension => [{
            :name => 'boom',
            :number => 20_000,
            :label => Google::Protobuf::FieldDescriptorProto::Label::LABEL_OPTIONAL,
            :type => Google::Protobuf::FieldDescriptorProto::Type::TYPE_STRING,
            :extendee => '.google.protobuf.FieldOptions',
          }],
        )
      end

      it 'generates the file contents that include the namespaced extension name' do
        subject.compile
        expect(subject.to_s).to eq <<EOF
# encoding: utf-8

##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'

module Test
  module Pkg
    module File_generator_spec

      ##
      # Extended Message Fields
      #
      class ::Google::Protobuf::FieldOptions < ::Protobuf::Message
        optional :string, :'test.pkg.file_generator_spec.boom', 20000, :extension => true
      end

    end

  end

end

EOF
      end
    end

  end

end
