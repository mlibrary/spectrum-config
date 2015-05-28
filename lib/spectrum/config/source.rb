# Copyright (c) 2015, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module Spectrum
  module Config
    class BaseSource
      attr_accessor :url, :type, :name, :driver
      def initialize args
        @url       = args['url']
        @type      = args['type']
        @name      = args['name']
        @driver    = args['driver']
        @link_key  = args['link_key']  || 'id'
        @link_type = args['link_type'] || :relative
        @link_base = args['link_base'] || nil
      end



      def link_to base, doc
        send @link_type, base, doc
      end

      def is_solr?
        false
      end

      def <=> b
        name <=> b.name
      end

      def merge! args = {}
        args.each_pair do |k,v|
          send (k.to_s + '=').to_sym, v
        end
      end

      def [] key
        send key.to_sym
      end

      def fix_params params, controller
        fixed_params = params.deep_clone
        %w(layout commit source sources controller action).each do |param_name|
          fixed_params.delete(param_name)
        end
        fixed_params.delete(:source)
        fixed_params['source'] = name
        fixed_params
      end

      private
      def first_value doc, key
        doc[key].listify.first
      end

      def rebase base, doc
        relative @link_base, doc
      end

      def relative base, doc
        "#{base}/#{first_value(doc, @link_key)}"
      end

      def absolute base, doc
        first_value doc, @link_key
      end
    end

    class SolrSource < BaseSource
      attr_accessor :truncate
      def initialize args
        super
        @truncate  = args['truncate']
      end

      def is_solr?
        true
      end

      def truncate?
        @truncate || false
      end
    end

    class SummonSource < BaseSource
      attr_accessor :access_id, :client_key, :secret_key, :log, :benchmark,
        :transport, :session_id
      def initialize args
        super
        @log        = args['log']        || nil
        @benchmark  = args['benchmark']  || nil
        @transport  = args['transport']  || nil
        @access_id  = args['access_id']  || nil
        @secret_key = args['secret_key'] || nil
        @client_key = args['client_key'] || nil
        @session_id = args['session_id'] || nil
      end

      def fix_params params, controller
        fixed_params = super(params, controller)

        # The Summon API support authenticated or un-authenticated roles,
        # with Authenticated having access to more searchable metadata.
        # We're Authenticated if the user is on-campus, or has logged-in.
        fixed_params['s.role'] = 'authenticated' if controller.on_campus? || controller.logged_in?

        # items-per-page (summon page size, s.ps, aka 'rows') should be
        # a persisent browser setting
        if fixed_params['s.ps'] && (fixed_params['s.ps'].to_i > 1)
          # Store it, if passed
          controller.set_browser_option('summon_per_page', fixed_params['s.ps'])
        else
          # Retrieve and use previous value, if not passed
          summon_per_page = controller.get_browser_option('summon_per_page')
          if summon_per_page && (summon_per_page.to_i > 1)
            fixed_params['s.ps'] = summon_per_page
          end
        end

        # Article searches within QuickSearch should act as New searches
        fixed_params['new_search'] = 'true' if controller.active_source == 'quicksearch'
        # QuickSearch is only one of may possible Aggregates - so maybe this instead?
        # params['new_search'] = 'true' if @search_style == 'aggregate'

        # If we're coming from the LWeb Search Widget - or any other external
        # source - mark it as a New Search for the Summon search engine.
        # (fixes NEXT-948 Article searches from LWeb do not exclude newspapers)
        #clios = ['http://clio', 'https://clio', 'http://localhost', 'https://localhost']
        #params['new_search'] = true unless request.referrer && clios.any? do |prefix|
          #request.referrer.starts_with? prefix
        #end

        # New approach, 5/14 - params will always be "q".  
        # "s.q" is internal only to the Summon controller logic
        if fixed_params['s.q']
          # s.q ovewrites q, unless 'q' is given independently
          fixed_params['q'] = fixed_params['s.q'] unless fixed_params['q']
          fixed_params.delete('s.q')
        end

        #   # LibraryWeb QuickSearch will pass us "search_field=all_fields",
        #   # which means to do a Summon search against 's.q'
        if fixed_params['q'] && fixed_params['search_field'] && (fixed_params['search_field'] != 'all_fields')
          hash = Rack::Utils.parse_nested_query("#{fixed_params['search_field']}=#{fixed_params['q']}")
          fixed_params.merge! hash
        end

        if fixed_params['pub_date']
          fixed_params['s.cmd'] = "setRangeFilter(PublicationDate,#{fixed_params['pub_date']['min_value']}:#{fixed_params['pub_date']['max_value']})"
        end

        fixed_params
      end
    end

    class SRWSource < BaseSource
    end

    class NullSource < BaseSource
    end

    class Source < SimpleDelegator
      def self.create args
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

      def initialize obj
        super
        @delegate_sd_obj = obj
      end

      def init_with args
        @delegate_sd_obj = Source.create args
      end

      def __getobj__
         @delegate_sd_obj
      end
      def __setobj__ obj
         @delegate_sd_obj = obj
      end
    end
  end
end
