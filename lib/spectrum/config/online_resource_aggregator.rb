# frozen_string_literal: true
module Spectrum
  module Config
    class OnlineResourceAggregator < Aggregator
      type 'online_resource'

      def initialize
        super
      end

      def add(metadata, field, subfield)
        return unless subfield
        @ret[field] ||= []
        @ret[field] << [metadata[:label], subfield]
      end

      def to_value
        headings = ['Link', 'Description', 'Source']
        resource = {
          caption: 'Online Resources',
          headings: headings,
          rows: [ ]
        }
        @ret.each_pair do |field, pairs|
          link = {}
          pairs.each do |pair|
            label, subfield = pair
            link[label] = subfield.value
          end
          next unless link['href']

          resource[:rows] << [
            {
              text: link['link_text'],
              href: link['href']
            },
            link['description'] || 'N/A',
            link['relationship'] || 'N/A'
          ]
        end
        resource
      end
    end
  end
end
