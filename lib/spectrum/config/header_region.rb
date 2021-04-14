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
        unless @header_component.nil?
          description = @header_component.get_description(data)
          unless description.nil?
            if description.is_a?(Array)
              description = description[0]
              if description.is_a?(Hash)
                description = description[:text]
                unless description.nil?
                  ret = {:region => @region, :name => @name , :description => description }
                end
              end
            end
          end
        end
        ret
      end

    end
  end
end
