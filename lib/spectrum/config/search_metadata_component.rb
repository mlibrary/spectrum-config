module Spectrum
  module Config
    class SearchMetadataComponent < MetadataComponent
      type 'search'

      attr_accessor :name, :search_type, :scope, :text_field, :value_field

      def initialize(name, config)
        config ||= {}
        self.name = name
        self.scope = config['scope']
        self.search_type = config['search_type']
        self.text_field = config['text_field']
        self.value_field = config['value_field']
      end

      def resolve(data)
        return nil if data.nil?
        description = [data].flatten(1).map { |item|
          if item.respond_to?(:[])
            {
              text: item[text_field],
              search: {
                type: search_type,
                scope: scope,
                value: item[value_field],
              }
            }
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
