module Spectrum
  module Config
    class Sort
      attr_accessor :weight, :id, :value, :metadata
      def initialize args = {}
        @id       = args['id']
        @value    = args['value']  || args['id']
        @group    = args['group']  || args['id']
        @weight   = args['weight'] || 0
        @metadata = Metadata.new(args['metadata'])
      end

      def spectrum
        {
           uid: @id,
           metadata: @metadata.spectrum,
           group: @group
        }
      end

      def <=> other
        self.weight <=> other.weight
      end

      def [] field
        if respond_to?(field.to_sym)
          self.send(field.to_sym)
        else
          nil
        end
      end

    end
  end
end
