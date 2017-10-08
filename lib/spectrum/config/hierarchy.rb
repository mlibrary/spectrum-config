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

      def initialize(hierarchy_def = {})
        @values = []
        @field  = hierarchy_def['field']
        @uid    = hierarchy_def['uid']
        aliases = hierarchy_def['aliases']
        inst = YAML.load_file(hierarchy_def['load_inst'])
        coll = YAML.load_file(hierarchy_def['load_coll'])
        inst.each_pair do |inst, inst_info|
          top_val = {
            value: inst,
            label: aliases['top'][inst] || inst,
            field: 'Location',
            uid: 'location',
            values: []
          }
          inst_info['sublibs'].each_pair do |loc_id, loc_name|
            middle_val = {
              value: loc_id,
              label: loc_name,
              field: 'Collection',
              uid: 'collection',
              values: []
            }
            coll[loc_id]['collections'].each_pair do |coll_id, coll_name|
              middle_val[:values] << {label: coll_name, value: coll_id}
            end
            top_val[:values] << middle_val
          end
          @values << top_val
        end
      end
    end
  end
end
