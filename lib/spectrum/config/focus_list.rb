module Spectrum
  module Config
    class FocusList < SimpleDelegator
      def self.create args
        args.sort.inject({}) { |ret, val| ret[val.name] = val; ret }
      end

      def by_category cat
        @delegate_sd_obj.values.map {|item| item.category_match(cat)}.compact
      end

      def initialize args
        @delegate_sd_obj = FocusList.create args
      end
    end
  end
end
