# encoding: utf-8

##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'
require 'protobuf/rpc/service'


##
# Imports
#
require 'google/protobuf/descriptor.pb'

module Protobuf_unittest

  ##
  # Enum Classes
  #
  class MethodOpt1 < ::Protobuf::Enum
    define :METHODOPT1_VAL1, 1
    define :METHODOPT1_VAL2, 2
  end

  class AggregateEnum < ::Protobuf::Enum
    define :VALUE, 1
  end


  ##
  # Message Classes
  #
  class TestMessageWithCustomOptions < ::Protobuf::Message
    class AnEnum < ::Protobuf::Enum
      define :ANENUM_VAL1, 1
      define :ANENUM_VAL2, 2
    end

  end

  class CustomOptionFooRequest < ::Protobuf::Message; end
  class CustomOptionFooResponse < ::Protobuf::Message; end
  class CustomOptionFooClientMessage < ::Protobuf::Message; end
  class CustomOptionFooServerMessage < ::Protobuf::Message; end
  class DummyMessageContainingEnum < ::Protobuf::Message
    class TestEnumType < ::Protobuf::Enum
      define :TEST_OPTION_ENUM_TYPE1, 22
      define :TEST_OPTION_ENUM_TYPE2, -23
    end

  end

  class DummyMessageInvalidAsOptionType < ::Protobuf::Message; end
  class CustomOptionMinIntegerValues < ::Protobuf::Message; end
  class CustomOptionMaxIntegerValues < ::Protobuf::Message; end
  class CustomOptionOtherValues < ::Protobuf::Message; end
  class SettingRealsFromPositiveInts < ::Protobuf::Message; end
  class SettingRealsFromNegativeInts < ::Protobuf::Message; end
  class ComplexOptionType1 < ::Protobuf::Message; end
  class ComplexOptionType2 < ::Protobuf::Message
    class ComplexOptionType4 < ::Protobuf::Message; end

  end

  class ComplexOptionType3 < ::Protobuf::Message; end
  class VariousComplexOptions < ::Protobuf::Message; end
  class AggregateMessageSet < ::Protobuf::Message; end
  class AggregateMessageSetElement < ::Protobuf::Message; end
  class Aggregate < ::Protobuf::Message; end
  class AggregateMessage < ::Protobuf::Message; end
  class NestedOptionType < ::Protobuf::Message
    class NestedEnum < ::Protobuf::Enum
      define :NESTED_ENUM_VALUE, 1
    end

    class NestedMessage < ::Protobuf::Message; end

  end

  class OldOptionType < ::Protobuf::Message
    class TestEnum < ::Protobuf::Enum
      define :OLD_VALUE, 0
    end

  end

  class NewOptionType < ::Protobuf::Message
    class TestEnum < ::Protobuf::Enum
      define :OLD_VALUE, 0
      define :NEW_VALUE, 1
    end

  end

  class TestMessageWithRequiredEnumOption < ::Protobuf::Message; end


  ##
  # Message Fields
  #
  class TestMessageWithCustomOptions
    optional :string, :field1, 1
  end

  class ComplexOptionType1
    optional :int32, :foo, 1
    optional :int32, :foo2, 2
    optional :int32, :foo3, 3
    repeated :int32, :foo4, 4
    # Extension Fields
    extensions 100...536870912
    optional :int32, :quux, 7663707, :extension => true
    optional ::Protobuf_unittest::ComplexOptionType3, :corge, 7663442, :extension => true
  end

  class ComplexOptionType2
    class ComplexOptionType4
      optional :int32, :waldo, 1
    end

    optional ::Protobuf_unittest::ComplexOptionType1, :bar, 1
    optional :int32, :baz, 2
    optional ::Protobuf_unittest::ComplexOptionType2::ComplexOptionType4, :fred, 3
    repeated ::Protobuf_unittest::ComplexOptionType2::ComplexOptionType4, :barney, 4
    # Extension Fields
    extensions 100...536870912
    optional :int32, :grault, 7650927, :extension => true
    optional ::Protobuf_unittest::ComplexOptionType1, :garply, 7649992, :extension => true
  end

  class ComplexOptionType3
    optional :int32, :qux, 1
  end

  class AggregateMessageSet
    # Extension Fields
    extensions 4...2147483647
    optional ::Protobuf_unittest::AggregateMessageSetElement, :message_set_extension, 15447542, :extension => true
  end

  class AggregateMessageSetElement
    optional :string, :s, 1
  end

  class Aggregate
    optional :int32, :i, 1
    optional :string, :s, 2
    optional ::Protobuf_unittest::Aggregate, :sub, 3
    optional ::Google::Protobuf::FileOptions, :file, 4
    optional ::Protobuf_unittest::AggregateMessageSet, :mset, 5
  end

  class AggregateMessage
    optional :int32, :fieldname, 1
  end

  class NestedOptionType
    class NestedMessage
      optional :int32, :nested_field, 1
    end

  end

  class OldOptionType
    required ::Protobuf_unittest::OldOptionType::TestEnum, :value, 1
  end

  class NewOptionType
    required ::Protobuf_unittest::NewOptionType::TestEnum, :value, 1
  end


  ##
  # Extended Message Fields
  #
  class ::Google::Protobuf::FileOptions < ::Protobuf::Message
    optional :uint64, :file_opt1, 7736974, :extension => true
    optional ::Protobuf_unittest::Aggregate, :fileopt, 15478479, :extension => true
    optional ::Protobuf_unittest::Aggregate, :nested, 15476903, :extension => true
    optional :int32, :nested_extension, 7912573, :extension => true
  end

  class ::Google::Protobuf::MessageOptions < ::Protobuf::Message
    optional :int32, :message_opt1, 7739036, :extension => true
    optional :bool, :bool_opt, 7706090, :extension => true
    optional :int32, :int32_opt, 7705709, :extension => true
    optional :int64, :int64_opt, 7705542, :extension => true
    optional :uint32, :uint32_opt, 7704880, :extension => true
    optional :uint64, :uint64_opt, 7702367, :extension => true
    optional :sint32, :sint32_opt, 7701568, :extension => true
    optional :sint64, :sint64_opt, 7700863, :extension => true
    optional :fixed32, :fixed32_opt, 7700307, :extension => true
    optional :fixed64, :fixed64_opt, 7700194, :extension => true
    optional :sfixed32, :sfixed32_opt, 7698645, :extension => true
    optional :sfixed64, :sfixed64_opt, 7685475, :extension => true
    optional :float, :float_opt, 7675390, :extension => true
    optional :double, :double_opt, 7673293, :extension => true
    optional :string, :string_opt, 7673285, :extension => true
    optional :bytes, :bytes_opt, 7673238, :extension => true
    optional ::Protobuf_unittest::DummyMessageContainingEnum::TestEnumType, :enum_opt, 7673233, :extension => true
    optional ::Protobuf_unittest::DummyMessageInvalidAsOptionType, :message_type_opt, 7665967, :extension => true
    optional ::Protobuf_unittest::ComplexOptionType1, :complex_opt1, 7646756, :extension => true
    optional ::Protobuf_unittest::ComplexOptionType2, :complex_opt2, 7636949, :extension => true
    optional ::Protobuf_unittest::ComplexOptionType3, :complex_opt3, 7636463, :extension => true
    optional ::Protobuf_unittest::Aggregate, :msgopt, 15480088, :extension => true
    optional ::Protobuf_unittest::OldOptionType, :required_enum_opt, 106161807, :extension => true
    optional ::Protobuf_unittest::ComplexOptionType2::ComplexOptionType4, :complex_opt4, 7633546, :extension => true
  end

  class ::Google::Protobuf::FieldOptions < ::Protobuf::Message
    optional :fixed64, :field_opt1, 7740936, :extension => true
    optional :int32, :field_opt2, 7753913, :default => 42, :extension => true
    optional ::Protobuf_unittest::Aggregate, :fieldopt, 15481374, :extension => true
  end

  class ::Google::Protobuf::EnumOptions < ::Protobuf::Message
    optional :sfixed32, :enum_opt1, 7753576, :extension => true
    optional ::Protobuf_unittest::Aggregate, :enumopt, 15483218, :extension => true
  end

  class ::Google::Protobuf::EnumValueOptions < ::Protobuf::Message
    optional :int32, :enum_value_opt1, 1560678, :extension => true
    optional ::Protobuf_unittest::Aggregate, :enumvalopt, 15486921, :extension => true
  end

  class ::Google::Protobuf::ServiceOptions < ::Protobuf::Message
    optional :sint64, :service_opt1, 7887650, :extension => true
    optional ::Protobuf_unittest::Aggregate, :serviceopt, 15497145, :extension => true
  end

  class ::Google::Protobuf::MethodOptions < ::Protobuf::Message
    optional ::Protobuf_unittest::MethodOpt1, :method_opt1, 7890860, :extension => true
    optional ::Protobuf_unittest::Aggregate, :methodopt, 15512713, :extension => true
  end


  ##
  # Service Classes
  #
  class TestServiceWithCustomOptions < ::Protobuf::Rpc::Service
    rpc :foo, ::Protobuf_unittest::CustomOptionFooRequest, ::Protobuf_unittest::CustomOptionFooResponse
  end

  class AggregateService < ::Protobuf::Rpc::Service
    rpc :method, ::Protobuf_unittest::AggregateMessage, ::Protobuf_unittest::AggregateMessage
  end

end

