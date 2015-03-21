module Spectrum
  module Config
    class BaseFocus
      attr_accessor :name, :weight, :title, :sources, :search_box
      def initialize args
        @title      = args['title']
        @name       = args['name']
        @weight     = args['weight']
        @sources    = args['sources']
        @search_box = args['search_box']
      end

      def <=> other
        self.weight <=> other.weight
      end
    end

    class SingleFocus < BaseFocus
    end

    class MultiFocus < BaseFocus
    end

    class NullFocus < BaseFocus
    end

    class Focus < SimpleDelegator
      def self.create args
        case args['type']
        when 'single', :single
          SingleFocus.new args
        when 'multi', :multi, 'multiple', :multiple
          MultiFocus.new args
        else
          NullFocus.new args
        end
      end

      def initialize obj
        super
        @delegate_sd_obj = obj
      end

      def init_with args
        @delegate_sd_obj = Focus.create args
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
