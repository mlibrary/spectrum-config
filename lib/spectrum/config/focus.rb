module Spectrum
  module Config
    class BaseFocus
    end

    class SingleFocus < BaseFocus
    end

    class MultiFocus < BaseFocus
    end

    class NullFocus
    end

    class Focus < SimpleDelegator
      def self.create args
        case args['type']
        when 'single', :single
          SingleFocus.new args
        when 'multiple', :multiple
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
        @delegate_sd_obj = create args
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
