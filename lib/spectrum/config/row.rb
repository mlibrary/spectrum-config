# frozen_string_literal: true
# Copyright (c) 2015, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module Spectrum
  module Config
    class Row
      attr_accessor :row_opts, :source, :count, :display_footer,
                    :render_options, :title, :description, :warning

      def initialize(data)
        @title    = data['title'] || data['source']
        @source   = data['source']
        @description = data['description']
        @display_footer = data['display_footer']
        @count    = data['count'] || 10
        @row_opts = data['row_opts'] || []
        @warning  = data['warning']
        @render_options = data['render_options'] || { format: 'clio', template: 'standard_list_item' }
      end
    end
  end
end
