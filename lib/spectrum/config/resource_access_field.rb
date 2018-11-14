module Spectrum
  module Config
    class ResourceAccessField < Field
      type 'resource_access'

      attr_reader :fields, :caption, :headings, :caption_link, :notes, :name

      def initialize_from_instance(i)
        super
        @name = i.name
        @notes = i.notes
        @fields = i.fields
        @headings = i.headings
        @caption = i.caption
        @caption_link = i.caption_link
      end

      def initialize_from_hash(args, config = {})
        super
        @name = args['name']
        @notes = args['notes']
        @fields = args['fields']
        @headings = args['headings']
        @caption = args['caption']
        @caption_link = args['caption_link']
      end

      def value(data, request = nil)
        values = {}
        @fields&.each do |field|
          if field['value']
            val = field['value']
          elsif field['preferred']
            val = field['preferred'].map { |fld| resolve_key(data, fld) }.join('')
          else
            val = nil
          end

          if field['fields'] && (val.nil? || val.empty?)
            val = field['fields'].map { |fld| resolve_key(data, fld) }.join('')
          elsif field['parallel']
            val = resolve_key(data, field['parallel'])
          end

          values[field['uid']] = val
        end

        rows = []
        if values['href'].respond_to? :each
          values['href'].each_with_index do |href, index|
            row = []
            link_text = values['link_text'].respond_to?(:each) ?
              values['link_text'][index] :
              values['link_text']
            relationship = values['relationship'].respond_to?(:each) ?
              values['relationship'][index] :
              values['relationship']
            row << {href: href, text: link_text}
            row << {text: relationship} if relationship
            rows << row.map { |cell| cell.delete_if { |k,v| v.nil? } }
          end
        else
          row = []
          if values['href'] && values['link_text']
            row << { href: values['href'], text: values['link_text']}
          end
          if values['relationship']
            row << { text: values['relationship']}
          end
          rows << row.map { |cell| cell.delete_if { |k,v| v.nil? } }
        end
        return nil if rows.nil? || rows.empty?
        {
          caption: caption,
          headings: headings,
          captionLink: caption_link,
          notes: notes,
          name: name,
          rows: rows
        }.delete_if { |k,v| v.nil? }
      end
    end
  end
end
