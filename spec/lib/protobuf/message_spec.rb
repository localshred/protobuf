require 'spec_helper'

describe Protobuf::Message do

  describe '#initialize' do 
    it "does not try to set attributes which have nil values" do 
      Test::EnumTestMessage.any_instance.should_not_receive("non_default_enum=")
      test_enum = Test::EnumTestMessage.new(:non_default_enum => nil)
    end

    it "takes a hash as an initialization argument" do 
      test_enum = Test::EnumTestMessage.new(:non_default_enum => 2)
      test_enum.non_default_enum.should eq(2)
    end

    it "initializes with an object that responds to #to_hash" do 
      hashie_object = OpenStruct.new(:to_hash => { :non_default_enum => 2 })      
      test_enum = Test::EnumTestMessage.new(hashie_object)
      test_enum.non_default_enum.should eq(2)
    end
  end

  describe "boolean predicate methods" do 
    subject { Test::ResourceFindRequest.new(:name => "resource") }

    it { should respond_to(:active?) }

    it "sets the predicate to true when the boolean value is true" do 
      subject.active = true
      subject.active?.should be_true
    end

    it "sets the predicate to false when the boolean value is false" do 
      subject.active = false
      subject.active?.should be_false
    end

    it "does not put predicate methods on non-boolean fields" do 
      Test::ResourceFindRequest.new(:name => "resource").should_not respond_to(:name?)
    end
  end

  describe "#respond_to_and_has?" do 
    subject { Test::EnumTestMessage.new(:non_default_enum => 2) }

    it "is false when the message does not have the field" do 
      subject.respond_to_and_has?(:other_field).should be_false
    end

    it "is true when the message has the field" do 
      subject.respond_to_and_has?(:non_default_enum).should be_true
    end
  end

  describe "#respond_to_has_and_present?" do 
    subject { Test::EnumTestMessage.new(:non_default_enum => 2) }

    it "is false when the message does not have the field" do 
      subject.respond_to_and_has_and_present?(:other_field).should be_false
    end

    it "is false when the field is repeated and a value is not present" do 
      subject.respond_to_and_has_and_present?(:repeated_enums).should be_false
    end

    it "is false when the field is repeated and the value is empty array" do 
      subject.repeated_enums = []
      subject.respond_to_and_has_and_present?(:repeated_enums).should be_false
    end

    it "is true when the field is repeated and a value is present" do 
      subject.repeated_enums = [2]
      subject.respond_to_and_has_and_present?(:repeated_enums).should be_true
    end

    it "is true when the message has the field" do 
      subject.respond_to_and_has_and_present?(:non_default_enum).should be_true
    end

    context "#API" do 
      subject { Test::EnumTestMessage.new(:non_default_enum => 2) }
        
      it { should respond_to(:respond_to_and_has_and_present?) }
      it { should respond_to(:responds_to_and_has_and_present?) }
      it { should respond_to(:responds_to_has?) }
      it { should respond_to(:respond_to_has?) }
      it { should respond_to(:respond_to_has_present?) }
      it { should respond_to(:responds_to_has_present?) }
      it { should respond_to(:respond_to_and_has_present?) }
      it { should respond_to(:responds_to_and_has_present?) }
    end
   
  end

  describe '#to_hash' do
    context 'generating values for an ENUM field' do
      it 'converts the enum to its tag representation' do
        hash = Test::EnumTestMessage.new(:non_default_enum => :TWO).to_hash
        hash.should eq({ :non_default_enum => 2 })
      end

      it 'does not populate default values' do
        hash = Test::EnumTestMessage.new.to_hash
        hash.should eq(Hash.new)
      end

      it 'converts repeated enum fields to an array of the tags' do
        hash = Test::EnumTestMessage.new(:repeated_enums => [ :ONE, :TWO, :TWO, :ONE ]).to_hash
        hash.should eq({ :repeated_enums => [ 1, 2, 2, 1 ] })
      end
    end

    context 'generating values for a Message field' do
      it 'recursively hashes field messages' do
        hash = Test::Nested.new({ :resource => { :name => 'Nested' } }).to_hash
        hash.should eq({ :resource => { :name => 'Nested' } })
      end

      it 'recursively hashes a repeated set of messages' do
        proto = Test::Nested.new(:multiple_resources => [
          Test::Resource.new(:name => 'Resource 1'),
          Test::Resource.new(:name => 'Resource 2')
        ])

        proto.to_hash.should eq({ :multiple_resources => [ { :name => 'Resource 1' },
                                                           { :name => 'Resource 2' } ] })

      end
    end
  end

  describe '#to_json' do
    subject do
      ::Test::ResourceFindRequest.new({ :name => 'Test Name', :active => false })
    end

    its(:to_json) { should eq '{"name":"Test Name","active":false}' }
  end

  describe '#get_field_by_name' do
    subject do
      ::Test::Resource.new({ :name => 'Test Name', :date_created => Time.now.to_i })
    end

    context 'when name is a valid field' do
      let(:valid_field) { subject.get_field_by_name(:name) }
      specify { valid_field.should be_a ::Protobuf::Field::StringField }
      specify { valid_field.name.should eq :name }
    end

    context 'when name is not a valid field' do
      specify do
        expect {
          subject.get_field_by_name(1)
        }.to raise_error(::Protobuf::Message::FieldNotDefinedError, /.*1.*#{subject.class.name}/)
      end

      specify do
        expect {
          subject.get_field_by_name(:nothere)
        }.to raise_error(::Protobuf::Message::FieldNotDefinedError, /.*nothere.*#{subject.class.name}/)
      end

      specify do
        expect {
          subject.get_field_by_name(nil)
        }.to raise_error(::Protobuf::Message::FieldNotDefinedError, /.*nil.*#{subject.class.name}/)
      end
    end
  end

  describe '#get_ext_field_by_name' do
    pending 'Need to get a proto compiled with extensions first'
  end

  describe '#get_field_by_tag' do
    subject do
      ::Test::Resource.new({ :name => 'Test Name', :date_created => Time.now.to_i })
    end

    context 'when tag references a valid field' do
      let(:valid_field) { subject.get_field_by_tag(1) }
      specify { valid_field.should be_a ::Protobuf::Field::StringField }
      specify { valid_field.name.should eq :name }
    end

    context 'when tag does not reference a field' do
      it 'returns nil' do
        pending 'need to implement a range-limiting array sub-class for field access'
        subject.get_field_by_tag(-1).should be_nil
      end
    end

    context 'when tag is not numeric' do
      specify do
        expect {
          subject.get_field_by_tag("not a number")
        }.to raise_error(::Protobuf::Message::FieldNotDefinedError, /.*not a number.*#{subject.class.name}/)
      end

      specify do
        expect {
          subject.get_field_by_tag(nil)
        }.to raise_error(::Protobuf::Message::FieldNotDefinedError, /.*nil.*#{subject.class.name}/)
      end
    end
  end

end
