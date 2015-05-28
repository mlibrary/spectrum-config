# Copyright (c) 2015, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module Spectrum
  module Config
    class Layout
      attr_accessor :style, :columns
      def initialize obj
        init_with(obj)
      end

      def init_with obj
        @style   = obj['style']   || 'single'
        @columns = obj['columns'] || []
        @columns.each do |col|
          col['width'] ||= 12
          col['searches'] ||= []
          col['searches'].each do |search|
            search['row_opts'] ||= []
            search['source']   ||= nil
            search['count']    ||= 10
            search['display_footer'] ||= false
            search['render_options'] ||= {}
          end
        end
      end
    end
  end
end
