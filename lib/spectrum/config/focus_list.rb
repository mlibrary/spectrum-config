module Spectrum
  module Config
    class FocusList < SimpleDelegator
      def self.create args
        args.sort.inject({}) {|ret, val| ret[val.name] = val}
      end

      def init_with args
        @delegate_sd_obj = FocusList.create args
      end
    end
  end
end
