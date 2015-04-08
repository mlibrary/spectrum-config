module Spectrum
  module Config
    class BaseSource
      attr_accessor :url, :type, :name, :driver
      def initialize args
        @url    = args['url']
        @type   = args['type']
        @name   = args['name']
        @driver = args['driver']
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
