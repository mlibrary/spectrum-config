# frozen_string_literal: true
# Copyright (c) 2015, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module Spectrum
  module Config
    class BaseSource
      attr_accessor :url, :type, :id, :driver, :path, :id_field, :holdings
      def initialize(args)
        @id        = args['id']
        @id_field  = args['id_field'] || 'id'
        @name      = args['name']
        @url       = args['url']
        @type      = args['type']
        @driver    = args['driver']
        @link_key  = args['link_key']  || 'id'
        @link_type = args['link_type'] || :relative
        @link_base = args['link_base']
        @holdings  = args['holdings']
        @conditionals = args['conditionals'] || {}
      end

      def fetch_record(field, id, _ = nil)
        client = driver.constantize.connect(url: url)
        result = client.get('select', params: { q: "#{field}:#{RSolr.solr_escape(id)}" })
        return {} unless result &&
                         result['response'] &&
                         result['response']['docs']
        result['response']['docs'].first || {}
      end

      def link_to(base, doc)
        send @link_type, base, doc
      end

      def is_solr?
        false
      end

      def <=>(b)
        id <=> b.id
      end

      def merge!(args = {})
        args.each_pair do |k, v|
          send (k.to_s + '=').to_sym, v
        end
      end

      def [](key)
        send key.to_sym
      end

      def params(focus, request, _controller = nil)
        request.query(focus.fields, focus.facet_map).merge(source: self,
                                                           'source' => self)
      end

      def engine(_focus, _request, _controller = nil)
        nil
      end

      private

      def first_value(doc, key)
        doc[key].listify.first
      end

      def rebase(_base, doc)
        relative @link_base, doc
      end

      def relative(base, doc)
        "#{base}/#{first_value(doc, @link_key)}"
      end

      def absolute(_base, doc)
        first_value doc, @link_key
      end
    end

    class SolrSource < BaseSource
      attr_accessor :truncate
      def initialize(args)
        super
        @truncate = args['truncate']
      end

      def is_solr?
        true
      end

      def truncate?
        @truncate || false
      end

      def engine(focus, request, controller = nil)
        p = params(focus, request, controller)
        p[:config] = ::Blacklight::Configuration.new do |config|
          focus.configure_blacklight(config, request)
        end
        p[:fq] += focus.filters
        p[:sort] = focus.get_sorts(request) if request.can_sort?
        p[:config].default_solr_params = focus.solr_params
        p[:qt] = focus.solr_params['qt'] if focus.solr_params['qt']
        p[:qf] = focus.solr_params['qf'] if focus.solr_params['qf']
        p[:pf] = focus.solr_params['pf'] if focus.solr_params['pf']
        p[:mm] = focus.solr_params['mm'] if focus.solr_params['mm']
        p[:tie] = focus.solr_params['tie'] if focus.solr_params['tie']
        engine = Spectrum::SearchEngines::Solr.new(p)
        engine.results.slice(*request.slice)
        engine
      end

      def params(focus, request, controller = nil)
        new_params = super
        @conditionals.each_pair do |condition, fq|
          if request.respond_to?(condition) && request.send(condition)
            new_params[:fq] << fq
          end
        end
        new_params
      end
    end

    class SummonSource < BaseSource
      attr_accessor :access_id, :client_key, :secret_key, :log, :benchmark,
                    :transport, :session_id
      def initialize(args)
        super
        @log        = args['log']        || nil
        @benchmark  = args['benchmark']  || nil
        @transport  = args['transport']  || nil
        @access_id  = args['access_id']  || nil
        @secret_key = args['secret_key'] || nil
        @client_key = args['client_key'] || nil
        @session_id = args['session_id'] || nil
      end

      def fetch_record(field, id, role = 'authenticated')
        engine = Spectrum::SearchEngines::Summon.new('s.fids' => id,
                                                     's.role' => role,
                                                     'source' => self,
                                                     source: self)
        return {} unless engine && engine.documents
        engine.documents.first || {}
      end

      def engine(focus, request, controller)
        Spectrum::SearchEngines::Summon.new(params(focus, request, controller))
      end

      def params(focus, request, controller = nil)
        new_params = super
        new_params.delete(:fq)

        new_params['s.fvf'] = request.fvf
        new_params['s.rff'] = request.rff
        new_params['s.rf']  = request.rf

        # The Summon API support authenticated or un-authenticated roles,
        # with Authenticated having access to more searchable metadata.
        # We're Authenticated if the user is on-campus, or has logged-in.
        new_params['s.role'] = 'authenticated' if request.authenticated?

        # items-per-page (summon page size, s.ps, aka 'rows') should be
        # a persisent browser setting
        if new_params['s.ps'] && (new_params['s.ps'].to_i > 1)
          # Store it, if passed
          # controller.set_browser_option('summon_per_page', new_params['s.ps'])
        end

        # Article searches within QuickSearch should act as New searches
        # new_params['new_search'] = 'true' if controller.active_source == 'quicksearch'
        # QuickSearch is only one of may possible Aggregates - so maybe this instead?
        # params['new_search'] = 'true' if @search_style == 'aggregate'

        # If we're coming from the LWeb Search Widget - or any other external
        # source - mark it as a New Search for the Summon search engine.
        # (fixes NEXT-948 Article searches from LWeb do not exclude newspapers)
        # clios = ['http://clio', 'https://clio', 'http://localhost', 'https://localhost']
        # params['new_search'] = true unless request.referrer && clios.any? do |prefix|
        # request.referrer.starts_with? prefix
        # end
        new_params['new_search'] = true

        # New approach, 5/14 - params will always be "q".
        # "s.q" is internal only to the Summon controller logic
        if new_params['s.q']
          # s.q ovewrites q, unless 'q' is given independently
          new_params['q'] = new_params['s.q'] unless new_params['q']
          new_params.delete('s.q')
        end
        new_params['s.sort'] = (focus.sorts.values.find { |sort| sort.uid == request.sort } || focus.sorts.default).value

        #   # LibraryWeb QuickSearch will pass us "search_field=all_fields",
        #   # which means to do a Summon search against 's.q'
        if new_params['q'] && new_params['search_field'] && (new_params['search_field'] != 'all_fields')
          hash = Rack::Utils.parse_nested_query("#{new_params['search_field']}=#{new_params['q']}")
          new_params.merge! hash
        end

        if new_params['pub_date']
          new_params['s.cmd'] = "setRangeFilter(PublicationDate,#{new_params['pub_date']['min_value']}:#{new_params['pub_date']['max_value']})"
        end

        new_params['s.ho'] = request.holdings_only? ? 'true' : 'false'

        new_params['s.fvf'] << 'IsScholarly,true' if request.is_scholarly?
        new_params['s.fvf'] << 'IsOpenAccess,true' if request.is_open_access?

        if request.exclude_newspapers?
          new_params['s.fvf'] << 'ContentType,Newspaper\ Article,true'
        end

        new_params['s.fvf'] << 'IsFulltext,true' if request.available_online?

        new_params['s.bookMark'] = request.book_mark if request.book_mark?

        new_params
      end
    end

    class SRWSource < BaseSource
    end

    class NullSource < BaseSource
    end

    module Source
      def self.new(args)
        case args['type']
        when 'summon', :summon
          SummonSource.new args
        when 'solr', :solr
          SolrSource.new args
        when 'srw', :srw
          SRWSource.new args
        else
          NullSource.new args
        end
      end
    end
  end
end
