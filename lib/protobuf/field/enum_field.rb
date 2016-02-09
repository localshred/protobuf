require 'protobuf/field/varint_field'

module Protobuf
  module Field
    class EnumField < VarintField

      ##
      # Class Methods
      #

      def self.default
        fail NoMethodError, "#{self}.#{__method__} must be called on an instance"
      end

      ##
      # Public Instance Methods
      #

      def acceptable?(val)
        !type_class.fetch(val).nil?
      end

      def encode(value)
        super(value.to_i)
      end

      def decode(value)
        value if acceptable?(value)
      end

      def enum?
        true
      end

      private

      ##
      # Private Instance Methods
      #

      def define_decode_setter
        field = self
        field_name = field.name
        field_type_class = field.type_class
        tag_method_name = "_protobuf_decode_setter_#{field.tag}"

        message_class.class_eval do
          define_method(tag_method_name) do |val|
            @encode = nil
            @values[field_name] = field_type_class.fetch(val)
          end
        end
      end

      def define_setter
        field = self
        field_name = field.name
        field_type_class = field.type_class

        message_class.class_eval do
          define_method("#{field_name}=") do |value|
            @encode = nil
            orig_value = value
            if value.nil?
              @values.delete(field_name)
            else
              value = field_type_class.fetch(value)
              fail TypeError, "Invalid Enum value: #{orig_value.inspect} for #{field.name}" unless value

              @values[field_name] = value
            end
          end
        end
      end

      def typed_default_value
        if default.is_a?(Symbol)
          type_class.const_get(default)
        else
          type_class.fetch(default) || type_class.enums.first
        end
      end

    end
  end
end
