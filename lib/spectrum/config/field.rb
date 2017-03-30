module Spectrum
  module Config
    class Field
      attr_accessor :weight, :id, :fixed, :weight, :default, :required,
                    :has_html, :metadata, :facet, :filters

      attr_reader :list, :full, :viewable, :searchable, :type, :marcfields,
                  :subfields, :uid, :model_field, :field, :openurl_root,
                  :openurl_field, :direct_link_field, :sorts, :bookplates,
                  :collapse, :fields, :query_params, :values

      def pseudo_facet?
        @type == 'pseudo_facet'
      end

      def searchable?
        @searchable
      end

      def empty?
        false
      end

      def initialize(args = {}, config = {})
        args ||= {}
        if String === args
          initialize_from_instance(config[args])
        else
          initialize_from_hash(args, config)
        end
      end

      def initialize_from_instance(i)
        @id = i.id
        @fixed = i.fixed
        @field = i.field
        @weight = i.weight
        @default = i.default
        @required = i.required
        @has_html = i.has_html
        @list = i.list
        @full = i.full
        @viewable = i.viewable
        @searchable = i.searchable
        @facet = i.facet
        @metadata = i.metadata
        @type = i.type
        @marcfields = i.marcfields
        @subfields = i.subfields
        @uid = i.uid
        @model_field = i.model_field
        @openurl_root = i.openurl_root
        @openurl_field = i.openurl_field
        @direct_link_field = i.direct_link_field
        @sorts = i.sorts
        @filters = i.filters
        @bookplates = i.bookplates
        @collapse = i.collapse
        @fields = i.fields
        @query_params = i.query_params
        @values = i.values
      end

      def initialize_from_hash(args, config)
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
        @collapse = args['collapse']
        @bookplates = config.bookplates
        @fields = args['fields']
        @query_params = args['query_params'] || {}
        @values = args['values'] || []

        @sorts      = (args['sorts'] || [])
        raise "Missing sort id(s): #{(@sorts - config.sorts.keys).join(', ')}" unless (@sorts - config.sorts.keys).empty?
        @sorts.map! { |sort| config.sorts[sort] }

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
        if @type == 'marcxml'
          record = MARC::XMLReader.new(StringIO.new(value)).first
          ret = []
          record.fields(@marcfields).each do |field|
            val = []
            @subfields.each_pair do |label, code|
              payload = field.find_all { |subfield| subfield.code == code }.map(&:value)
              if @collapse
                ret = ret + payload unless payload.empty?
              else
                val << {
                  uid: "#{@marcfields}#{code}",
                  name: label,
                  value: payload,
                  value_has_html: @has_html
                } unless payload.empty?
              end
            end
            ret << val unless @collapse
          end
          ret
        elsif @type == 'summon_date'
          [value.day, value.month, value.year].compact.join('/')
        else
          value
        end
      end

      def summon_access_url(data)
        if (data.src[@model_field].first == 'OpenURL')
          @openurl_root + '?' + data.send(@openurl_field)
        else
          data.send(@direct_link_field)
        end
      end

      def bookplate(data)
        return nil unless data[@field].respond_to?(:each)
        data[@field].each do |fund|
          if @bookplates[fund]
            return [
              {
                'uid' => 'desc',
                'name' => 'Description',
                'value' => @bookplates[fund].desc,
                'value_has_html' => false
              },
              {
                'uid' => 'image',
                'name' => 'Image',
                'value' => @bookplates[fund].image,
                'value_has_html' => false
              }
            ]
          end
        end
      end

      def concat(data)
        return @field.map {|name| resolve_key(data, name)}.join('')
      end

      def parallel_merge(data)
        ret = []
        flds = @fields.map do |field|
          [field['uid'], resolve_key(data, field['field'])]
        end.to_h
        0.upto(flds.first.length) do |i|
          ret << @fields.map do |field|
            {
              'uid' => field['uid'],
              'name' => field['name'],
              'value' => flds[field['uid']][i],
              'value_has_html' => true,
            }
          end
        end
        ret
      end

      def value(data)
        if @type == 'summon_access_url'
          return summon_access_url(data)
        elsif @type == 'bookplate'
          return bookplate(data)
        elsif @type == 'concat'
          return concat(data)
        elsif @type == 'parallel_merge'
          return parallel_merge(data)
        end
        resolve_key(data, @field)
      end

      def resolve_key(data, name)
        if data.respond_to?(:[])
          return transform(data[name])
        elsif data.respond_to?(name)
          return transform(data.send(name))
        elsif data.respond_to?(:src)
          return transform(data.src[name])
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
