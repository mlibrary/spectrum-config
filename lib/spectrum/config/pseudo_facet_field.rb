# frozen_string_literal: true
module Spectrum
  module Config
    class PseudoFacetField < Field
      type 'pseudo_facet'

      def pseudo_facet?
        true
      end
    end
  end
end
