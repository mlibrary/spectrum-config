# frozen_string_literal: true
module Spectrum
  module Config
    class SolrYearField < Field
      type 'solr_year'

      def transform(value)
        value&.slice(0, 4)
      end
    end
  end
end
