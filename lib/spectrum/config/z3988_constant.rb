require 'uri'

module Spectrum
  module Config
    class Z3988Constant
      attr_accessor :id, :namespace, :constant

      def initialize(args)
        self.id = args['id'] if args
        self.constant = args['constant'] if args
        self.namespace = args['namespace'] || '' if args
      end

      def value(_ = nil)
        if id && constant
          "#{URI::encode_www_form_component(id)}=#{URI::encode_www_form_component(namespace + constant)}"
        else
          [ ]
        end
      end
    end
  end
end
