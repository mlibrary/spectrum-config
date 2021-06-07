module Spectrum
  module SearchEngines
    module Primo
      class Doc

        attr_reader :data, :extras, :delivery

        def self.for_json(json)
          self.new(
            data: json['pnx'],
            extras: json['extras'],
            delivery: json['delivery']
          )
        end

        def initialize(data: {}, extras: {}, delivery: {})
          @data = data
          @extras = extras
          @delivery = delivery
        end

        def [](key)
          if data['display'].has_key?(key)
            return data['display'][key]
          elsif data['addata'].has_key?(key)
            return data['addata'][key]
          elsif data['search'].has_key?(key)
            return data['search'][key]
          elsif data['control'].has_key?(key)
            return data['control'][key]
          end
        end
      end
    end
  end
end
