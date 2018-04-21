# frozen_string_literal: true
# Copyright (c) 2015, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module Spectrum
  module Config
    class Column
      DEFAULT_WIDTH = 12
      BASE_CSS_CLASS = 'result_column'
      attr_accessor :width, :rows

      def initialize(data = {})
        @width = data['width'] || DEFAULT_WIDTH
        @rows = RowList.new(data['rows'])
      end

      def classes
        "#{BASE_CSS_CLASS} col-sm-#{width}"
      end

      def sources
        rows.map(&:source)
      end
    end
  end
end
