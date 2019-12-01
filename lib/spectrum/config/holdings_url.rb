# frozen_string_literal: true
module Spectrum
  module Config
    class HoldingsURL
      attr_accessor :field, :prefix

      UID = 'holdings_url'
      NAME = 'Holdings URL'
      HAS_HTML = false
      DEFAULT_FIELD = 'id'
      DEFAULT_PREFIX = ''

      def initialize(args = {})
        args ||= {}
        @field  = args['field'] || DEFAULT_FIELD
        @prefix = args['prefix'] || DEFAULT_PREFIX
      end

      def apply(data, base_url, request)
        if data.respond_to? :[]
          apply_hash(data, base_url, request)
        else
          apply_object(data, base_url, request)
        end
      end

      def apply_object(data, base_url, request)
        value = data.send(@field.to_sym)
        value = data.send(DEFAULT_FIELD.to_sym) if value.nil?
        apply_value(value, base_url, request)
      end

      def apply_hash(data, base_url, request)
        value = data[@field]
        value = data[DEFAULT_FIELD] if value.nil?
        apply_value(value, base_url, request)
      end

      def apply_value(value, base_url, request)
        if value.nil?
          value = ''
        elsif value === Array
          value = value.join('/')
        end

        htso = if request&.htso?
          ':htso'
        else
          ''
        end

        {
          uid: UID,
          name: NAME,
          value: "#{base_url}/#{@prefix}/holdings/#{value}#{htso}",
          value_has_html: HAS_HTML
        }
      end
    end
  end
end
