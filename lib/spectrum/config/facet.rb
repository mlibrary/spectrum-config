module Spectrum
  module Config
    class Facet
      attr_accessor :weight, :id, :limit, :mincount, :offset

      DEFAULT_SORTS = {'count' => 'count', 'index' => 'index'}

      def initialize args = {}, sort_list = [], url = ''
        @id           = args['id']
        @more         = args['more']     || false
        @fixed        = args['fixed']    || false
        @values       = args['values']   || []
        @default      = args['default']  || false
        @required     = args['required'] || false
        @mincount     = args['mincount'] || 1
        @limit        = args['limit']    || 20
        @offset       = args['offset']   || 0
        @metadata     = Metadata.new(args['metadata'])
        @url          = url + '/' + @id

        sorts         = args['sorts'] || DEFAULT_SORTS
        @sorts        = Spectrum::Config::SortList.new(sorts, sort_list)
        @default_sort = @sorts[args['default_sort']] || @sorts.default
      end

      def routes(source, focus, app)
        app.match @url,
          to: 'json#facet',
          defaults: { source: source, focus: focus, facet: @id, type: 'Facet' },
          via: [:post, :options]
        app.get @url, to: 'json#bad_request'
      end

      def sort
        @default_sort.id
      end

      def more data, base_url
        if data.length > @limit * 2
          base_url + @url
        else
          false
        end
      end

      def values(data)
        if data.length > @limit * 2
          data.slice(0, @limit * 2)
        else
          data
        end.each_slice(2).map { |kv| {value: kv[0], name: kv[0], count: kv[1]} }
      end

      def spectrum(data, base_url)
        data ||= []
        {
          uid: @id,
          default_value: @default,
          values: values(data),
          fixed: @fixed,
          required: @required,
          more: more(data, base_url),
          sorts: @sorts.spectrum,
          default_sort: @default_sort.id,
          metadata: @metadata.spectrum
        }
      end

      def name
        @metadata.name
      end

      def <=> other
        self.weight <=> other.weight
      end
    end
  end
end
