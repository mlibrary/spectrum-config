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
        @where = arg['where']
        @default = arg['default']
      end

      def match_field(field)
        if @tag.match(field.tag)
          match_indicators(field) && match_where(field)
        else
          false
        end
      end

      def match_subfield(subfield)
        @sub.match(subfield.code)
      end

      def match_indicators(field)
        return true unless field.respond_to?(:indicator1) && field.respond_to?(:indicator2)
        @ind1.match(field.indicator1) && @ind2.match(field.indicator2)
      end

      def match_where(field)
        return true unless @where
        return true unless field.respond_to?(:find_all)
        @where.all? do |clause|
          if clause['not']
            ret = false
            values = [clause['not']].flatten
          elsif clause['is']
            ret = true
            values = [clause['is']].flatten
          end
          subfields = field.find_all do |subfield|
            /#{clause['sub']}/.match(subfield.code) &&
              values.include?(subfield.value)
          end
          if subfields.length > 0
            ret
          else
            !ret
          end
        end
      end
    end
  end
end
