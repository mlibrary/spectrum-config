module Spectrum
  module Config
    class SummonDateField < Field
      type 'summon_date'

      def transform(value)
        [value.day, value.month, value.year].compact.join('/')
      end
    end
  end
end
