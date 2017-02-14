module Spectrum
  module Config
    class Href
      attr_accessor :field, :prefix

      UID = 'href'
      NAME = 'HREF'
      HAS_HTML = false
      DEFAULT_FIELD = 'id'
      DEFAULT_PREFIX = ''

      def initialize args = {}
        args ||= {}
        @field  = args['field'] || DEFAULT_FIELD
        @prefix = args['prefix'] || DEFAULT_PREFIX
      end

      def apply(data)
        if data.respond_to? :[]
          apply_hash(data)
        else
          apply_object(data)
        end
      end

      def apply_object(data)
        value = data.send(@field.to_sym)

        if value.nil?
          value = data.send(DEFAULT_FIELD.to_sym)
        end

        apply_value(value)
      end

      def apply_hash(data)
        value = data[@field]

        if value.nil?
          value = data[DEFAULT_FIELD]
        end
        apply_value(value)
      end

      def apply_value(value)

        if value.nil?
          value = ''
        elsif value === Array
          value = value.join('/')
        end

        {
          uid: UID,
          name: NAME,
          value: @prefix + value,
          value_has_html: HAS_HTML,
        }
      end

    end
  end
end
