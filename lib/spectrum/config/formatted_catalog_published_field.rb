module Spectrum
  module Config
    class FormattedCatalogPublishedField < Field
      type "formatted_catalog_published"

      attr_reader :fields
      def initialize_from_instance(i)
        super
        @fields = i.fields
      end

      def initialize_from_hash(args, config)
        super
        @fields = {}
        args['fields'].each_pair do |fname, fdef|
          @fields[fname] = Field.new(
            fdef.merge({'id' => SecureRandom.uuid, 'metadata' => {}}),
            config
          )
        end
      end

      def value(data)
        ret = ''
        date = @fields['pub_date'].value(data)
        date = date.first unless date.nil?
        pub  = @fields['publisher'].value(data)
        pub  = pub.join(' ') unless pub.nil?
        ret << date if String === date
        ret << " - " + pub if String === pub
        ret
      end

    end
  end
end
    
