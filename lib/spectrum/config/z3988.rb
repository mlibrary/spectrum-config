require 'uri'

module Spectrum
  module Config
    class Z3988
      attr_accessor :id, :namespace

      def initialize(args)
        self.id = args['id'] if args
        self.namespace = args['namespace'] || '' if args
      end

      def value(data)
        if id && data && data[:value]
          [data[:value]].flatten.map do |val|
            "#{URI::encode(id)}=#{URI::encode(namespace + val)}"
          end
        else
          [ ]
        end
      end
    end
  end
end
