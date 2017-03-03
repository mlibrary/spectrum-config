module Spectrum
  module Config
    class Field
      attr_accessor :weight, :id, :fixed, :weight, :default, :required,
                    :has_html, :metadata, :facet, :filters

      def initialize args = {}, sort_list = {}
        args ||= {}
        raise args.inspect unless args['metadata']
        @id         = args['id']
        @fixed      = args['fixed']      || false
        @weight     = args['weight']     || 0
        @default    = args['default']    || ""
        @required   = args['required']   || false
        @has_html   = args['has_html']   || false
        @list       = args['list']       || true
        @full       = args['full']       || true
        @viewable   = args['viewable'].nil?   ? true : args['viewable']
        @searchable = args['searchable'].nil? ? true : args['searchable']
        @facet      = FieldFacet.new(args['facet'])
        @metadata   = Metadata.new(args['metadata'])
        @type       = args['type'] || 'solr'
        @field      = args['field'] || args['id']
        @marcfields = args['marcfields']
        @subfields  = args['subfields']
        @uid        = args['uid'] || args['id']
        @model_field = args['model_field']
        @openurl_root = args['openurl_root']
        @openurl_field = args['openurl_field']
        @direct_link_field = args['direct_link_field']

        @sorts      = (args['sorts'] || [])
        raise "Missing sort id(s): #{(@sorts - sort_list.keys).join(', ')}" unless (@sorts - sort_list.keys).empty?
        @sorts.map! { |sort| sort_list[sort] }

        @filters = FilterList.new(args['filters'] || [])
        #raise "Missing filter id(s): #{(@filters - filter_list.keys).join(', ')}" unless (@filters - filter_list.keys).empty?
        #@filters.map! { |filter| filter_list[filter] }

      end

      def list?
        @list
      end

      def full?
        @full
      end

      def [] field
        if respond_to?(field.to_sym)
          self.send(field.to_sym)
        else
          nil
        end
      end

      def name
        @metadata.name
      end

      def spectrum
        if @searchable
          {
            uid: @uid,
            metadata: @metadata.spectrum,
            required: @required,
            fixed: @fixed,
            default_value: @default,
          }
        else
          nil
        end
      end

      def transform(value)
        if @type == 'solr'
          value
        elsif @type == 'marcxml'
          record = MARC::XMLReader.new(StringIO.new(value.first)).first
          record.fields(@marcfields).map do |field|
            hsh = {
              uid: @uid,
              name: @metadata.name,
              value: [],
              value_has_html: @has_html
            }
            @subfields.each_pair do |label, code|
              hsh[:value] << {
                uid: "#{@marcfields}#{code}",
                name: label,
                value:  field.find_all { |subfield| subfield.code == code }.map(&:value),
                value_has_html: @has_html
              }
            end
            hsh
          end
        elsif @type == 'summon_date'
          [value.day, value.month, value.year].compact.join('/')
        end
      end

      def summon_access_url(data)
        if (data.src[@model_field].first == 'OpenURL')
          @openurl_root + '?' + data.send(@openurl_field)
        else
          data.send(@direct_link_field)
        end
      end

      def value(data)
        if @type == 'summon_access_url'
          return summon_access_url(data)
        end

        if data.respond_to?(:[])
          transform(data[@field])
        elsif data.respond_to?(@field)
          transform(data.send(@field))
        elsif data.respond_to?(:src)
          transform(data.src[@field])
        end
      end

      def apply(data)
        val = @filters.apply(value(data))
        if @viewable && valid_data?(val)
          {
            uid: @uid,
            name: @metadata.name,
            value: val,
            value_has_html: @has_html,
          }
        else
          nil
        end
      end

      def <=> other
        self.weight <=> other.weight
      end

      private
      def valid_data?(data)
        if data.nil?
          false
        elsif data.respond_to?(:empty?)
          if data.respond_to?(:all?) && !data.empty?
            if data.all? { |item| item.respond_to?(:empty?) && !item.empty? }
              true
            else
              data.length > 0
            end
          else
            !data.empty?
          end
        else
          data
        end
      end
    end
  end
end
