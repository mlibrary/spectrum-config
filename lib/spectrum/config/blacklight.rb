# Copyright (c) 2015, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module Spectrum
  module Config
    class Blacklight
   
      def initialize obj = {}
        set obj
      end

      def init_with obj
        set obj
      end

      def configure config, search_fields
        config.per_page                      = @per_page
        config.spell_max                     = @spell_max
        config.default_solr_params           = @default_solr_params
        config.document_solr_request_handler = @request_handler

        @show.each_pair do |name, field|
          config.show.send (name + '=').to_sym, field
        end

        @index.each_pair do |name, field|
          config.index.send (name + '=').to_sym, field
        end

        @index_field.each do |field|
          options = {}
          options[:label] = field['label'] if field.has_key? 'label'
          options[:separator] = field['separator'] if field.has_key? 'separator'
          config.add_index_field field['name'], options
        end

        @search_fields.each do |name|
          search_fields[name].configure(config)
        end

        #FACET_FIELD_CONFIG.configure config, @facet_fields
        #SEARCH_FIELD_CONFIG.configure config, @search_fields
      end

      private
      def set obj
        @show            = obj['show'] || {}
        @index           = obj['index'] || {}
        @per_page        = obj['per_page'] || [10, 25, 50, 100]
        @spell_max       = obj['spell_max'] || 0
        @index_field     = obj['index_field'] || []
        @facet_fields    = obj['facet_fields'] || []
        @search_fields   = obj['search_fields'] || []
        @request_handler = obj['request_handler'] || 'document'
        @default_solr_params  = obj['default_solr_params']
      end
    end
  end
end
