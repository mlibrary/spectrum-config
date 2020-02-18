module Spectrum
  module Config
    class ImageMetadataComponent < MetadataComponent
      type 'image'

      attr_accessor :name, :text_field, :image_field

      def initialize(name, config)
        config ||= {}
        self.name = name
        self.text_field = config['text_field']
        self.image_field = config['image_field']
      end

      def resolve_value(item, uid)
        return nil unless item.respond_to?(:find)
        (item.find {|attr| attr[:uid] == uid} || {})[:value]
      end

      def resolve_description(data)
        [data].flatten(1).map { |item|
          text = resolve_value(item, text_field)
          image = resolve_value(item, image_field)
          if text && image
            {
              text: text,
              image: image,
            }
          else
            nil
          end
        }.compact
      end

      def resolve(data)
        return nil if data.nil?
        description = resolve_description(data)
        return nil if description.empty?
        {
          term: name,
          description: description,
        }
      end
    end
  end
end
