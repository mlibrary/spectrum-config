module Spectrum
  module Config
    class MarcMatcher
      attr_reader :label, :join, :default

      def metadata
        {
          label: label,
          join: join
        }
      end

      def initialize(arg)
        @label = arg['label'] || "#{arg['tag']} #{arg['ind1']}#{arg['ind2']} #{arg['sub']}"
        @join  = arg['join']
        @tag   = %r{#{arg['tag'] || '.'}}
        @sub   = %r{#{arg['sub'] || '.'}}
        @ind1  = %r{#{arg['ind1'] || '.'}}
        @ind2  = %r{#{arg['ind2'] || '.'}}
        @default = arg['default']
      end

       def match_field(field)
         @tag.match(field.tag) && @ind1.match(field.indicator1) && @ind2.match(field.indicator2)
       end

       def match_subfield(subfield)
         @sub.match(subfield.code)
       end
    end
  end
end
