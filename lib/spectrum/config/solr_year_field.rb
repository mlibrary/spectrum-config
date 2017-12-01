module Spectrum
  module Config
    class SolrYearField < Field
      type 'solr_year'

      def transform(value)
        value.slice(0, 4) if value
      end
    end
  end
end
