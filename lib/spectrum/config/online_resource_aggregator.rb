# frozen_string_literal: true
module Spectrum
  module Config
    class OnlineResourceAggregator < Aggregator
      type 'online_resource'

      def initialize
        super
        @links = {}
        @metadata = {}
      end

      def add(metadata, field, subfield)
        return unless subfield
        if field.tag == "856"
          @links[field] ||= {}
          @links[field][metadata[:label]] = subfield.value
        else
          @metadata[metadata[:label]] ||= []
          @metadata[metadata[:label]] << subfield.value
        end
      end

      def to_value
        base = if is_only_electronic?
          if is_book?
            to_book_value.merge(preExpanded: true)
          else
            to_other_value.merge(preExpanded: true)
          end
        else
          to_other_value.merge(preExpanded: false)
        end
        return nil if base[:rows].empty?
        base.merge(
          caption: 'Online Resources',
          type: 'electronic',
        )
     end

     def is_book?
       @metadata['format']&.any? { |format| format == 'Book' }
     end

     def is_only_electronic?
       return true unless @metadata['location']
       @metadata['location'].reject do |location|
         location == 'FLINT'
       end.all? do |location|
         ['ELEC', 'SDR'].any? do |match|
           location.include?(match)
         end
       end
     end

     def to_other_value
        headings = ['Link', 'Description', 'Source']
        rows = []
        @links.each_pair do |field, link|
          next unless link['href']
          rows << [
            {
              text: link['link_text'],
              href: link['href']
            },
            {text: link['description'] || 'N/A'},
            {text: link['source'] || 'N/A'}
          ]
        end
        {headings: headings, rows: rows}
     end

     def to_book_value
        headings = ['Link', 'Action', 'Description', 'Source']
        rows = []

        @links.each_pair do |field, link|
          next unless link['href']

          rows << [
            {
              text: link['link_text'],
              href: link['href']
            },
            {
              text: 'Get This',
              to: {
                barcode: 'available-online',
                action: 'get-this',
                record: @metadata['id'].first,
                datastore: 'mirlyn'
              }
            },
            {text: link['description'] || 'N/A'},
            {text: link['source'] || 'N/A'}
          ]
        end
        {headings: headings, rows: rows}
      end
    end
  end
end
