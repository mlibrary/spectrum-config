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
        @base       = args['base']
        @map        = args['map']
        @uid        = args['uid'] || args['id']

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

      def apply data
        if @viewable && valid_data?(data)
          {
            uid: @id,
            name: @metadata.name,
            value: @filters.apply(data),
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
