# frozen_string_literal: true
module Spectrum
  module Config
    class ConcatField < Field
      type 'concat'

      def value(data)
        @field.map { |name| resolve_key(data, name) }.join('')
      end
    end
  end
end
