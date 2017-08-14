module Spectrum
  module Config
    class FieldFacet
      attr_reader :sorts, :ranges, :type

      def initialize data = {}
        data ||= {}
        @sorts = data['sorts']
        @ranges = data['ranges']
        @type   = data['type']
      end

    end
  end
end
