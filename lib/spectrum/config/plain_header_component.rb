module Spectrum
  module Config
    class PlainHeaderComponent < HeaderComponent
      type 'plain'

      def initialize(region, config)
        self.region = region
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
        return data if Hash === data && data[:region] && data[:description]
        description = get_description(data)
        return nil if description.empty?

        {
          region: region,
          description: description,
        }
      end
    end
  end
end
