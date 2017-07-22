module Spectrum
  module Config
    class CollapsingAggregator < Aggregator
      type 'collapsing'

      def add(metadata, field, subfield)
        @ret[field] ||= []
        @ret[field] << subfield.value
      end

      def to_value
         @ret.values
      end
    end
  end
end
