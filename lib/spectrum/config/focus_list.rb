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
        if arg.respond_to?(:has_key?) && arg.has_key?('active_source') 
          match(arg['active_source'])
        else
          key = arg.to_s.gsub(/^\/advanced/, '').gsub(/^\//, '')
          if @delegate_sd_object.has_key? key
            key
          else
            nil
          end
        end
      end

      def default
        @delegate_sd_obj.keys.first
      end
    end
  end
end
