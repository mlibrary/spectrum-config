module Spectrum
  module SearchEngines
    module Primo
      class Doc

        attr_reader :data, :extras, :delivery

        def self.for_json(json, position)
          self.new(
            data: json['pnx'],
            extras: json['extras'],
            delivery: json['delivery'],
            position: position
          )
        end

        def initialize(data: {}, extras: {}, delivery: {}, position: 0)
          @data = data
          @extras = extras
          @delivery = delivery
          @data['internal'] = {
            'position' => position,
            'id' => [(data['control'] || {})['recordid']].flatten.first,
          }
        end

        def fulltext?
          @delivery['availability'].include?('fulltext')
        end

        def [](key)
          ['control', 'display', 'addata', 'search', 'internal', 'facets'].each do |area|
            if data[area].has_key?(key)
              return data[area][key]
            end
          end
          return nil
        end
      end
    end
  end
end
