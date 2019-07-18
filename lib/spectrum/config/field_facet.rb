# frozen_string_literal: true
module Spectrum
  module Config
    class FieldFacet
      attr_reader :sorts, :ranges, :type, :expanded

      def initialize(data = {})
        data ||= {}
        @sorts = data['sorts']
        @ranges = data['ranges']
        @type   = data['type']
        @expanded = data['expanded']
      end
    end
  end
end
