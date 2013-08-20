require 'spec_helper'

require 'protobuf/generators/enum_generator'

describe ::Protobuf::Generators::EnumGenerator do

  let(:values) {
    [
      { :name => 'FOO', :number => 1 },
      { :name => 'BAR', :number => 2 },
      { :name => 'BAZ', :number => 3 }
    ]
  }
  let(:enum_fields) { { :name => 'TestEnum',
                        :value => values } }

  let(:enum) { ::Google::Protobuf::EnumDescriptorProto.new(enum_fields) }

  subject { described_class.new(enum) }

  describe '#compile' do
    let(:compiled) {
      %q{class TestEnum < ::Protobuf::Enum
  define :FOO, 1
  define :BAR, 2
  define :BAZ, 3
end

}
    }

    it 'compiles the enum and it\'s field values' do
      subject.compile
      subject.to_s.should eq(compiled)
    end
  end

  describe '#build_value' do
    it 'returns a string identifying the given enum value' do
      subject.build_value(enum.value.first).should eq("define :FOO, 1")
    end
  end

end

