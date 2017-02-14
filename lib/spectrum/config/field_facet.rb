module Spectrum
  module Config
    class FieldFacet
      attr_reader :sorts

      def initialize data = {}
        data ||= {}
        @sorts = data['sorts']
      end

    end
  end
end
