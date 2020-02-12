module Spectrum
  module Config
    class IconMetadataComponent < MetadataComponent
      type 'icon'

      attr_accessor :icon_field, :text_field

      def initialize(name, config)
        config ||= {}
        self.name = name
        self.icon_field = config['icon_field'] || 'icon'
        self.text_field = config['text_field'] || 'text'
      end

      def resolve(data)
        return nil if data.nil?
        description = [data].flatten(1).map { |item|
          if item.respond_to?(:[])
            {text: item[text_field], icon: item[icon_field]}
          else
            nil
          end
        }.compact
        return nil if description.empty?
        {
          term: name,
          description: description,
        }
      end
    end
  end
end
