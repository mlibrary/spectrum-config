module Spectrum
  module Config
    class Field
      class << self

        def new(field_def, config)
          type = get_type(field_def, config)
          return type.new(field_def, config) if type
          obj = self.allocate
          obj.send(:initialize, field_def, config)
          obj
        end

        def inherited(base)
          registry << base
        end

        def type(t = nil)
          @type = t if t
          @type
        end

        private

        def get_type(field_def, config)
          reindex!
          return index[field_def['type']] if index[field_def['type']]
          return index[field_def.type] if field_def.respond_to?(:type) && index[field_def.type]
          return index[config[field_def].type] if config.respond_to?(:[]) && config[field_def]
          return registry.first if registry.length > 0
          nil
        end

        def reindex!
          return unless dirty?
          registry.each do |item|
            index[item.type] = item
          end
        end

        def registry
          @registry ||= []
        end

        def dirty?
          registry.length > index.length
        end

        def index
          @index ||= {}
        end
      end

      attr_accessor :weight, :id, :fixed, :weight, :default, :required,
                    :has_html, :metadata, :facet, :filters

      attr_reader :list, :full, :viewable, :searchable, :uid,
                  :field, :sorts, :fields, :query_params, :values,
                  :query_field

      type 'default'

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
        @uid = i.uid
        @sorts = i.sorts
        @filters = i.filters
        @query_params = i.query_params
        @values = i.values
        @origin = 'instance'
        @query_field = i.query_field
      end

      def initialize_from_hash(args, config)
        raise args.inspect unless args['metadata']
        @origin     = 'hash'
        @id         = args['id']
        @fixed      = args['fixed']      || false
        @weight     = args['weight']     || 0
        @default    = args['default']    || ""
        @required   = args['required']   || false
        @has_html   = true #args['has_html']   || false
        @list       = args['list']       || true
        @full       = args['full']       || true
        @viewable   = args['viewable'].nil?   ? true : args['viewable']
        @searchable = args['searchable'].nil? ? true : args['searchable']
        @facet      = FieldFacet.new(args['facet'])
        @metadata   = Metadata.new(args['metadata'])
        @field      = args['field'] || args['id']
        @query_field = args['query_field'] || @field
        @uid        = args['uid'] || args['id']
        @query_params = args['query_params'] || {}
        @values = args['values'] || []

        @sorts      = (args['sorts'] || [])
        raise "Missing sort id(s): #{(@sorts - config.sorts.keys).join(', ')}" unless (@sorts - config.sorts.keys).empty?
        @sorts.map! { |sort| config.sorts[sort] }

        @filters = FilterList.new((args['filters'] || []) + [{"id" => "decode", "method" => "decode"}])
      end

      def type
        self.class.type
      end

      def pseudo_facet?
        false
      end

      def searchable?
        @searchable
      end

      def empty?
        false
      end

      def initialize(args = {}, config = {})
        if String === args
          raise "Unknown field type '#{args}'" unless config.has_key?(args)
          initialize_from_instance(config[args])
        else
          initialize_from_hash(args, config)
        end
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
        value
      end

      def value(data)
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
