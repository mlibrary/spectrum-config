# frozen_string_literal: true
module Spectrum
  module Config
    class MoreInformationField < Field
      type 'more_information'

      def value(value, request)
        {
          term: name,
          description: super(value, request).map { |val| JSON.parse(val) }
        }
      end
    end
  end
end
