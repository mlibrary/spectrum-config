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

      def params(focus, request, controller)
        new_params = super
        return {
          q: 'any,contains,a'
        }
      end
    end
  end
end
