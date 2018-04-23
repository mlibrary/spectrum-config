# frozen_string_literal: true
module Spectrum
  module Config
    class FormattedArticlePublishedField < Field
      type 'formatted_article_published'

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
            fdef.merge('id' => SecureRandom.uuid, 'metadata' => {}),
            config
          )
        end
      end

      def value(data)
        pub_title = @fields['publication_title'].value(data)
        volume = @fields['volume'].value(data)
        issue = @fields['issue'].value(data)

        ret = String.new('')
        ret << pub_title if pub_title
        ret << ' Vol. ' + volume if volume
        ret << ', Issue ' + issue if issue
        ret
      end
    end
  end
end
