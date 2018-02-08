module Spectrum
  module Config
    class NullFacet
      attr_accessor :weight, :id, :limit, :mincount, :offset
      attr_reader :uid, :field, :type
      DEFAULT_SORTS = {}
      def initialize
        @facet_field = @field = @uid = @id = 'null'
        @more = false
        @fixed = false
        @values = []
        @default = false
        @required = false
        @mincount = 1
        @limit = 20
        @offset = 0
        @metadata = Metadata.new({'name' => 'Null Facet'})
        @url = 'null'
        @type = 'null'
        @sorts = SortList.new
        @default_sort = nil
        @ranges = nil
      end

      [:pseudo_facet?, :rff, :routes, :sort, :label, :values, :spectrum, :name, :<=>, :more].each do |fn|
        define_method(fn) { |*arg| }
      end
    end

    class Facet
      attr_accessor :weight, :id, :limit, :mincount, :offset

      attr_reader :uid, :field, :type, :facet_field

      DEFAULT_SORTS = {'count' => 'count', 'index' => 'index'}

      def initialize(args = {}, sort_list = [], url = '')
        @id           = args['id']
        @uid          = args['uid'] || @id
        @field        = args['field'] || @uid
        @more         = args['more']     || false
        @fixed        = args['fixed']    || false
        @values       = args['values']   || []
        @default      = args['default']  || false
        @required     = args['required'] || false
        @mincount     = args['mincount'] || 1
        @limit        = args['limit']    || 20
        @offset       = args['offset']   || 0
        @metadata     = Metadata.new(args['metadata'])
        @url          = url + '/' + @uid
        @type         = args['facet'].type || args['type'] || args.type
        @ranges       = args['facet'].ranges

        sorts         = args['facet_sorts'] || DEFAULT_SORTS
        @sorts        = Spectrum::Config::SortList.new(sorts, sort_list)
        @default_sort = @sorts[args['default_facet_sort']] || @sorts.default
      end

      def pseudo_facet?
        @type == 'pseudo_facet'
      end

      def rff(applied)
        return nil if @ranges.nil? || @ranges.empty?
        return [field, *@ranges.map {|r| r['value']}].join(',') unless applied.data[@uid]

        values = Array(applied.data[@uid])
        range_matches = @ranges.find_all {|r| values.include?(r['value'])}
        return nil if range_matches.length != values.length
        return nil unless range_matches.all? {|r| r['divisible']}
        list = [field]
        values.each do |value|
          start, finish = value.split(/:/).map(&:to_i)
          (start..finish).each do |i|
            list << "#{i}:#{i}"
          end
        end
        list.join(",")
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

      def label(value)
        if @type == 'range'
          range = @ranges.find {|range| range['value'] == value }
          return range['label'] if range && range['label']
          range = value.split(/:/).map(&:to_i)
          return range.first.to_s if range[0] == range[1]
        end
        return value
      end

      def parents(value)
        Spectrum::Config::FacetParents.find(uid, value)
      end

      def values(data, lim = nil)
        lim ||= @limit
        if (lim >= 0 && data.length > lim * 2)
          data.slice(0, lim * 2)
        else
          data
        end.each_slice(2).map { |kv|
          {
            value: kv[0],
            name: label(kv[0]),
            count: kv[1],
            parents: parents(kv[0]),
          }
        }.reject {|i| i[:count] <= 0 }
      end

      def spectrum(data, base_url, args = {})
        data ||= []
        data = @values if data.empty?
        {
          uid: @uid,
          default_value: @default,
          values: values(data, args[:filter_limit]),
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
