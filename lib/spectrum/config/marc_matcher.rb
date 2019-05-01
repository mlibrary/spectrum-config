# frozen_string_literal: true
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
        @tag   = /#{arg['tag'] || '.'}/
        @sub   = /#{arg['sub'] || '.'}/
        @ind1  = /#{arg['ind1'] || '.'}/
        @ind2  = /#{arg['ind2'] || '.'}/
        @default = arg['default']
      end

      def match_field(field)
        if @tag.match(field.tag)
          return true unless field.respond_to?(:indicator1) && field.respond_to?(:indicator2)
          @ind1.match(field.indicator1) && @ind2.match(field.indicator2)
        else
          false
        end
      end

      def match_subfield(subfield)
        @sub.match(subfield.code)
      end
    end
  end
end
