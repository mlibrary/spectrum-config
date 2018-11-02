# frozen_string_literal: true
module Spectrum
  module Config
    class SummonResourceAccessField < Field
      type 'summon_resource_access'

      attr_reader :model_field, :openurl_root, :openurl_field, :direct_link_field,
        :name, :notes, :headings, :caption, :caption_link

      def initialize_from_instance(i)
        super
        @name = i.name
        @notes = i.notes
        @caption = i.caption
        @headings = i.headings
        @model_field = i.model_field
        @caption_link = i.caption_link
        @openurl_root = i.openurl_root
        @openurl_field = i.openurl_field
        @direct_link_field = i.direct_link_field
      end

      def initialize_from_hash(args, config)
        super
        @name = args['name']
        @notes = args['notes']
        @caption = args['caption']
        @headings = args['headings']
        @model_field = args['model_field']
        @caption_link = args['caption_link']
        @openurl_root = args['openurl_root']
        @openurl_field = args['openurl_field']
        @direct_link_field = args['direct_link_field']
      end

      def value(data, request = nil)
        return nil unless data
        return nil if data.respond_to?(:empty?) && data.empty?
        href = if data.src[@model_field].first == 'OpenURL'
          @openurl_root + '?' + data.send(@openurl_field)
        else
          data.send(@direct_link_field)
        end
        {
          headings: headings,
          caption: caption,
          captionLink: caption_link,
          notes: notes,
          name: name,
          rows: [
            {href: href, text: 'Go to item'}
          ]
        }
      end
    end
  end
end
