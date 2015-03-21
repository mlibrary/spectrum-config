module Spectrum
  module Config
    class FocusList < SimpleDelegator
      def self.create args
        args.values.sort {|a,b| a.weight <=> b.weight}
      end

      def init_with args
        @delegate_sd_obj = FocusList.create args
      end
    end
  end
end
