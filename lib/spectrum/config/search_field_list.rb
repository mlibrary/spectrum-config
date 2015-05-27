module Spectrum
  module Config
    class SearchFieldList < SimpleDelegator

      def self.load file
        new YAML.load(File.read(file))
      end

      def initialize field_list
        @delegate_sd_obj = field_list.inject({}) do |memo, field|
          memo[field['name']] = SearchField.new(field) 
          memo 
        end
      end

      def configure config, list
        list.each do |name| 
          @delegate_sd_obj[name].configure(config) if @delegate_sd_obj.has_key? name
        end
      end
      
    end
  end
end
    
