# Copyright (c) 2015, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module Spectrum
  module Config
    class FocusList < ConfigList
      CONTAINS = Focus

      def routes app
        __getobj__.each_value do |focus|
          focus.routes(app)
        end
      end

      def by_category cat
        __getobj__.values.map {|item| item.category_match(cat)}.compact
      end

      def match arg
        case arg
        when Hash
          arg.has_key?('active_source') ? match(arg['active_source']) : nil
        when String
          key = arg.gsub(/^\//, '').gsub(/\/advanced/, '')

          has_key?(key) ? key : nil
        else
          nil
        end
      end

      def spectrum
        __getobj__.values.map(&:spectrum)
      end

      def default
        __getobj__.keys.first
      end
    end
  end
end
