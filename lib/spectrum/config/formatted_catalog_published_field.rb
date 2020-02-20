# frozen_string_literal: true
module Spectrum
  module Config
    class FormattedCatalogPublishedField < Field
      type 'formatted_catalog_published'

      attr_reader :fields
      def initialize_from_instance(i)
        super
        @fields = i.fields
      end

      def initialize_from_hash(args, config)
        super
        @fields = {}
        args['fields'].each_pair do |fname, fdef|
          @fields[fname] = Field.new(
            fdef.merge('id' => SecureRandom.uuid, 'metadata' => {}),
            config
          )
        end
      end

      def value(data, request = nil)
        date = [@fields['pub_date'].value(data)].flatten.first
        date = date.strip unless date.nil?
        pub  = [@fields['publisher'].value(data)].flatten.reject do |item|
          item.nil? || item.empty?
        end.map do |item|
          [date, item].reject do |str|
            str.nil? || !(String === str) || str.empty?
          end.join(' - ')
        end
        return nil if pub.empty?
        pub
      end
    end
  end
end
