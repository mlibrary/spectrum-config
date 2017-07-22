module Spectrum
  module Config
    class Marc
      attr_reader :fields, :aggregator_type

      def initialize(marc)
        @fields = marc['fields'].map { |field| MarcMatcher.new(field) }
        @aggregator_type = marc['aggregator']
      end

      def aggregate(record)
        aggregator = Aggregator.new(aggregator_type)
        fields.each do |field_matcher|
          record.find_all { |field| field_matcher.match_field(field) }.each do |field|
            field.find_all { |subfield| field_matcher.match_subfield(subfield) }.each do |subfield|
              aggregator.add(field_matcher.metadata, field, subfield)
            end
          end
        end
        aggregator.to_value
      end

    end
  end
end
