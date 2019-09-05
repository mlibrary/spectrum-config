# frozen_string_literal: true
module Spectrum
  module Config
    class Hierarchy
      attr_accessor :field, :uid, :label, :value, :values

      def spectrum
        {
          field: @field,
          uid: @uid,
          values: @values
        }
      end

      def handles?(item)
        @handled_uids.include?(item)
      end

      def value_map
        @value_mapping
      end

      def initialize(hierarchy_def = {})
        @values = []
        @field  = hierarchy_def['field']
        @uid    = hierarchy_def['uid']
        @handled_uids = [@uid, 'location', 'collection']
        aliases = hierarchy_def['aliases']
        @value_mapping = aliases.fetch('tr', {})
        inst = YAML.load_file(hierarchy_def['load_inst'])
        coll = YAML.load_file(hierarchy_def['load_coll'])
        @handled_uids.each { |uid| @value_mapping[uid] ||= {} }
        inst.each_pair do |inst, inst_info|
          top_val = {
            value: inst,
            label: aliases['top'][inst] || inst,
            field: 'Location',
            uid: 'location',
            values: []
          }
          inst_info['sublibs'].each_pair do |loc_id, loc_name|
            @value_mapping['location'][loc_name] ||= loc_id
            middle_val = {
              value: loc_id,
              label: loc_name,
              field: 'Collection',
              uid: 'collection',
              values: []
            }
            (coll[loc_id] || {})['collections']&.each_pair do |coll_id, coll_name|
              @value_mapping['collection'][coll_name] ||= []
              @value_mapping['collection'][coll_name] << coll_id
              middle_val[:values] << { label: coll_name, value: coll_id }
            end
            top_val[:values] << middle_val
          end
          @values << top_val
        end
      end
    end
  end
end
