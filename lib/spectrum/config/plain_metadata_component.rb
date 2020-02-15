module Spectrum
  module Config
    class PlainMetadataComponent < MetadataComponent
      type 'plain'

      def initialize(name, config)
        self.name = name
      end

      def get_description(data)
        [data].flatten(1).map do |item|
          item = item.to_s
          if item.empty?
            nil
          else
            {text: item}
          end
        end.compact
      end

      def resolve(data)
        description = get_description(data)
        return nil if description.empty?

        {
          term: name,
          description: description,
        }
      end
    end
  end
end
