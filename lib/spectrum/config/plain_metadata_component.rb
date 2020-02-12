module Spectrum
  module Config
    class PlainMetadataComponent < MetadataComponent
      type 'plain'

      def initialize(name, config)
        self.name = name
      end

      def resolve(data)
        return nil if data.nil?
        description = [data].flatten(1).map {|item| {text: item}}

        return nil if description.empty?
        {
          term: name,
          description: description,
        }
      end
    end
  end
end
