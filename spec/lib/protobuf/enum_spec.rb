require 'spec_helper'

describe Protobuf::Enum do
  let(:name) { :THREE }
  let(:tag) { 3 }

  before(:all) do
    Test::EnumTestType.define(name, tag)
  end

  describe '.define' do
    it 'defines a constant enum value on the parent class' do
      Test::EnumTestType.constants.should include(name)
      Test::EnumTestType::THREE.should be_a(Protobuf::EnumValue)
    end
  end

  describe '.fetch' do
    context 'when value is an EnumValue' do
      it 'responds with that object' do
        Test::EnumTestType.fetch(Test::EnumTestType::THREE).should eq Test::EnumTestType::THREE
      end
    end

    context 'when value can be coerced to a symbol' do
      it 'fetches based on the symbol name value' do
        Test::EnumTestType.fetch("ONE").should eq Test::EnumTestType::ONE
      end
    end

    context 'when value can be coerced to an integer' do
      it 'fetches based on the integer tag value' do
        Test::EnumTestType.fetch(3.0).should eq Test::EnumTestType::THREE
      end
    end

    context 'when value is not an applicable type' do
      it 'returns a nil' do
        Test::EnumTestType.fetch(Test::Resource.new).should be_nil
      end
    end
  end

  describe '.enum_by_value' do
    it 'gets the EnumValue corresponding to the given value (tag)' do
      Test::EnumTestType.enum_by_value(tag).should eq Test::EnumTestType::THREE
    end
  end

  describe '.name_by_value' do
    it 'gets the name of the enum corresponding to the given value (tag)' do
      Test::EnumTestType.name_by_value(tag).should eq name
    end
  end

  describe '.valid_tag?' do
    context 'when tag is defined' do
      specify { Test::EnumTestType.valid_tag?(tag).should be_true }
    end

    context 'when tag is not defined' do
      specify { Test::EnumTestType.valid_tag?(300).should be_false }
    end
  end

  describe '.value_by_name' do
    it 'gets the EnumValue corresponding to the given name' do
      Test::EnumTestType.value_by_name(name).should eq Test::EnumTestType::THREE
    end
  end

  describe '.values' do
    it 'provides a hash of defined EnumValues' do
      Test::EnumTestType.values.should eq({
        :ONE   => Test::EnumTestType::ONE,
        :TWO   => Test::EnumTestType::TWO,
        :THREE => Test::EnumTestType::THREE
      })
    end
  end

  context 'when coercing from enum' do
    subject { Test::StatusType::PENDING }
    it { should eq(0) }
  end

  context 'when coercing from integer' do
    specify { 0.should eq(Test::StatusType::PENDING) }
  end
end
