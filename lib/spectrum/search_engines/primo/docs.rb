module Spectrum
  module SearchEngines
    module Primo
      module Docs
        def self.for_json(json)
          json.map {|doc_json| Doc.for_json(doc_json)}
        end
      end
    end
  end
end
