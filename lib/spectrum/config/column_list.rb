# Copyright (c) 2015, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module Spectrum
  module Config
    class ColumnList < SimpleDelegator
      def initialize list = []
        __setobj__(list.map { |item| Column.new(item)} )
      end

      def sources
        map(&:sources).flatten
      end
    end
  end
end
