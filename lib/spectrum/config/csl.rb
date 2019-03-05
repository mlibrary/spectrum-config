module Spectrum
  module Config
    module CSL
      def self.new(hsh)
        return CSLNull unless hsh
        case hsh['type']
        when 'array'
          CSLArray
        else
          CSLLiteral
        end.new(hsh['id'])
      end
    end
  end
end
