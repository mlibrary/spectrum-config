module Spectrum
  module Config
    class PrimoSource < BaseSource

      attr_accessor :key, :host, :tab, :scope, :view

      def initialize(args)
        super(args)
        @key   = args['key']
        @host  = args['host']
        @tab   = args['tab']
        @scope = args['scope']
        @view  = args['view']
      end

      def engine(focus, request, controller = nil)
        p = params(focus, request, controller)
        Spectrum::SearchEngines::Primo::Engine.new(
          key: key,
          host: host,
          tab: tab,
          scope: scope,
          view: view,
          params: p
        )
      end

      def extract_query(field, conjunction, tree )
        if tree.root_node?
          return 'any,contains,a' if tree.children.empty?
          return tree.children.map do |child|
            extract_query(field, conjunction, child)
          end.join(",#{conjunction};")
        end
        if tree.is_type?('tokens')
          return "#{field},contains,#{tree.text}"
        end
        if ['and','or', 'not'].any? {|type| tree.is_type?(type) }
          op = tree.operator.to_s.upcase
          return tree.children.map do |child|
            extract_query(field, op, child)
          end.join(",#{op};")
        end
        if tree.is_type?('fielded')
          return extract_query(tree.field, conjunction, tree.query)
        end
        ''
      end

      def extract_record_query(request)
        {
          q: "id,exact,#{request.instance_eval {@request.params}['id']}"
        }
      end

      def params(focus, request, controller)

        if Spectrum::Request::Record === request
          return extract_record_query(request)
        end

        {
          q: extract_query(
            focus.raw_config['search_field_default'] || 'any',
            'AND',
            request.build_psearch.search_tree
          )
        }
      end
    end
  end
end
