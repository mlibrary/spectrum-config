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

      def match arg
        case arg
        when Hash
          arg.has_key?('active_source') ? match(arg['active_source']) : nil
        when String
          @delegate_sd_obj.has_key?(arg) ? arg : nil
        else
          nil
        end
      end

      def default
        @delegate_sd_obj.keys.first
      end
    end
  end
end
