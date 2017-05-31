module Spectrum
  module Config
    class ConcatenateMergeField < Field
      type "concatenate_merge"

      attr_reader :fields

      def initialize_from_instance(i)
        super
        @fields = i.fields
      end

      def initialize_from_hash(args, config = {})
        super
        @fields = args['fields']
      end

      def value(data)
        # Wrap the result in an array for parity with ParallelMergeField.
        [
          @fields.map do |field|
            {
              'uid' =>  field['uid'],
              'name' => field['name'],
              'value' => field['fields'].map {|fld| resolve_key(data, fld) }.join(''),
              'value_has_html' => true,
            }
          end
        ]
      end
    end
  end
end
