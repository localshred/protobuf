module Protobuf
  module Field
    class FieldArray < Array
      ##
      # Constructor
      #
      def initialize(field)
        @field = field
      end

      ##
      # Public Instance Methods
      #
      def []=(nth, val)
        super(nth, normalize(val))
      end

      def <<(val)
        super(normalize(val))
      end

      def push(val)
        super(normalize(val))
      end

      def unshift(val)
        super(normalize(val))
      end

      def replace(val)
        raise TypeError unless val.is_a?(Array)
        val = val.map {|v| normalize(v)}
        super(val)
      end

      # Return a hash-representation of the given values for this field type.
      # The value in this case would be an array.
      def to_hash_value
        self.map do |value|
          value.respond_to?(:to_hash_value) ? value.to_hash_value : value
        end
      end

      def to_s
        "[#{@field.name}]"
      end

      private

      ##
      # Private Instance Methods
      #
      def normalize(value)
        raise TypeError unless @field.acceptable?(value)
        if @field.is_a?(::Protobuf::Field::EnumField)
          @field.type.fetch(value)
        elsif @field.is_a?(::Protobuf::Field::MessageField) && value.is_a?(Hash)
          @field.type.new(value)
        else
          value
        end
      end
    end
  end
end
