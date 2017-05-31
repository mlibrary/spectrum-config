module Spectrum
  module Config
    class ConcatField < Field
      type "concat"

      def value(data)
        return @field.map {|name| resolve_key(data, name)}.join('')
      end
    end
  end
end
