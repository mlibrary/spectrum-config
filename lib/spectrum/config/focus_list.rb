module Spectrum
  module Config
    class FocusList < ConfigList
      def add_routes app
        @delegate_sd_obj.each_value do |focus|
          focus.add_route(app)
        end
      end

      def by_category cat
        @delegate_sd_obj.values.map {|item| item.category_match(cat)}.compact
      end
    end
  end
end
