module Spectrum
  module Config
    class SummonDayField < Field
      type 'summon_day'

      def transform(value)
        value.day
      end
    end
  end
end
