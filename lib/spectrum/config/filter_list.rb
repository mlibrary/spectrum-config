# Copyright (c) 2015, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module Spectrum
  module Config
    class FilterList < MappedConfigList
      CONTAINS = Filter

      def apply data
        if __getobj__.empty?
          data
        else
          __getobj__.values.inject(data) { |memo, filter| filter.apply(memo) }
        end
      end
    end
  end
end
