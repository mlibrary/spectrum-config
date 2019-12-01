# frozen_string_literal: true
module Spectrum
  module Config
    class Href
      attr_accessor :field, :prefix

      UID = 'href'
      NAME = 'HREF'
      HAS_HTML = false
      DEFAULT_FIELD = 'id'
      DEFAULT_PREFIX = ''

      def initialize(args = {})
        args ||= {}
        @field  = args['field'] || DEFAULT_FIELD
        @prefix = args['prefix'] || DEFAULT_PREFIX
      end

      def apply(data, base_url, request)
        {
          uid: UID,
          name: NAME,
          value: get_url(data, base_url, request),
          value_has_html: HAS_HTML
        }
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
        value = if value.nil?
          ''
        elsif Array === value
          value.join('/')
        else
          value
        end

        htso = if request&.htso?
          ':htso'
        else
          ''
        end

        "#{base_url}/#{@prefix}/record/#{value}#{htso}"
      end

      def get_url(data, base_url, request)
        if data.respond_to? :[]
          apply_hash(data, base_url, request)
        else
          apply_object(data, base_url, request)
        end
      end
    end
  end
end
