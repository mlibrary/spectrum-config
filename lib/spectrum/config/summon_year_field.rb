module Spectrum
  module Config
    class SummonYearField < Field
      type 'summon_year'

      def transform(value)
        value.year
      end
    end
  end
end
