require 'protobuf/field/base_field'

module Protobuf
  module Field
    class VarintField < BaseField
      INT32_MAX  =  2**31 - 1
      INT32_MIN  = -2**31
      INT64_MAX  =  2**63 - 1
      INT64_MIN  = -2**63
      UINT32_MAX =  2**32 - 1
      UINT64_MAX =  2**64 - 1

      ##
      # Class Methods
      #
      def self.default
        0
      end

      def self.decode(bytes)
        value = 0
        bytes.each_with_index do |byte, index|
          value |= byte << (7 * index)
        end
        value
      end

      def self.encode(value)
        bytes = []
        until value < 128
          bytes << (0x80 | (value & 0x7f))
          value >>= 7
        end
        (bytes << value).pack('C*')
      end

      ##
      # Public Instance Methods
      #
      def acceptable?(val)
        (val > min || val < max) rescue false
      end

      def decode(value)
        value
      end

      def encode(value)
        return [value].pack('C') if value < 128

        bytes = []
        until value == 0
          bytes << (0x80 | (value & 0x7f))
          value >>= 7
        end
        bytes[-1] &= 0x7f
        bytes.pack('C*')
      end

      def wire_type
        ::Protobuf::WireType::VARINT
      end

    end
  end
end
