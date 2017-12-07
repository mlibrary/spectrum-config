module Spectrum
  module Config
    class MarcJSONField < Field
      type 'marcjson'

      def value(data)
        MARC::XMLReader.new(StringIO.new(super)).first.to_hash
      end
    end
  end
end