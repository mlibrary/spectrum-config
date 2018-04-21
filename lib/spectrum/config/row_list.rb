# frozen_string_literal: true
# Copyright (c) 2015, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module Spectrum
  module Config
    class RowList < SimpleDelegator
      def initialize(list = [])
        __setobj__(list.map { |item| Row.new(item) })
      end

      def sources
        map(&:source)
      end
    end
  end
end
