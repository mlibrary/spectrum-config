module Spectrum
  module Config
    class SolrMonthField < Field
      type 'solr_month'

      def transform(value)
        value.slice(5, 2).sub(/^0*/, '') if value
      end
    end
  end
end