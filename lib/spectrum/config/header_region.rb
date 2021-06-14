module Spectrum
  module Config
    class HeaderRegion

      def initialize(name, config)
        @name = name

        if config.is_a?(Hash)
          @region, component_config = config.first
        end

        @header_component = HeaderComponent.new(@name, component_config)
      end

      def resolve(data)
        return nil if @header_component.nil?
        description = @header_component.get_description(data)
        return nil if description.nil? || description.empty?
        {
          region: @region,
          description: description,
        }
      end

    end
  end
end
