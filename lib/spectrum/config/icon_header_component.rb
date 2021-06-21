module Spectrum
  module Config
    class IconHeaderComponent < HeaderComponent
      type 'icon'

      def initialize(region, config)
        self.region = region
      end

      def transform_item(item)
        item
      end

      def transform_icon(item)
        item
      end

      def get_description(data)
        [data].flatten(1).map do |item|
          item = item.to_s
          if item.empty?
            nil
          else
            ret = {}
            item = transform_item(item)
            icon = transform_icon(item)
            ret[:text] = item if item
            ret[:icon] = icon if icon
            if ret.empty?
              nil
            else
             ret
            end
          end
        end.compact
      end

    end
  end
end
