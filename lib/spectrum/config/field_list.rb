# Copyright (c) 2015, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module Spectrum
  module Config
    class FieldList < MappedConfigList
      CONTAINS = Field

      def apply data
        binding.pry
        data.map {|item| apply_fields(item) }.compact
      end

      def apply_fields item
        binding.pry
        __getobj__.map {|field| item}.compact
      end

      def list
        binding.pry
        __getobj__.map {|field| field.list? ? field : nil}.compact
      end

      def full
        binding.pry
        __getobj__.map {|field| field.full? ? field : nil}.compact
      end

    end
  end
end
