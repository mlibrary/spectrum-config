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

      def <=> b
        self.name <=> b.name
      end

      def merge! args = {}
        args.each_pair do |k,v|
          self.send k.to_sym, v
        end
      end
    end

    class SolrSource < BaseSource
    end

    class SummonSource < BaseSource
      attr_accessor :truncate
      def initialize args
        super
        @truncate = args['truncate']
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
