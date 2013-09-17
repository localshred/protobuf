# encoding: utf-8

require 'spec_helper'

describe ::Protobuf::Field::StringField do

  describe '#encode' do
    context 'when a repeated string field contains frozen strings' do
      it 'does not raise an encoding error' do
        expect {
          frozen_strings = [ "foo".freeze, "bar".freeze, "baz".freeze ]
          ::Test::ResourceFindRequest.new(:name => 'resource', :widgets => frozen_strings).serialize_to_string
        }.not_to raise_error
      end
    end

    context 'when a repeated bytes field contains frozen strings' do
      it 'does not raise an encoding error' do
        expect {
          frozen_strings = [ "foo".freeze, "bar".freeze, "baz".freeze ]
          ::Test::ResourceFindRequest.new(:name => 'resource', :widget_bytes => frozen_strings).serialize_to_string
        }.not_to raise_error
      end
    end

    it 'does not alter string values after encoding multiple times' do
      source_string = "foo"
      proto = ::Test::Resource.new(:name => source_string)
      proto.serialize_to_string
      proto.name.should eq source_string
      proto.serialize_to_string
      proto.name.should eq source_string
    end

    it 'does not alter unicode string values after encoding multiple times' do
      source_string = "¢"
      proto = ::Test::Resource.new(:name => source_string)
      proto.serialize_to_string
      proto.name.should eq source_string
      proto.serialize_to_string
      proto.name.should eq source_string
    end
  end


end
