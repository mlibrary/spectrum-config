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
          ['control', 'display', 'addata', 'search'].each do |area|
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
