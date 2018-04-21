# frozen_string_literal: true
# Copyright (c) 2015, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module Spectrum
  module Config
    class Layout
      attr_accessor :style, :columns
      def initialize(obj = {})
        init_with(obj)
      end

      def init_with(obj)
        @style   = obj['style'] || 'single'
        @columns = ColumnList.new(obj['columns'])
      end

      def sources
        @columns.sources
      end
    end
  end
end
