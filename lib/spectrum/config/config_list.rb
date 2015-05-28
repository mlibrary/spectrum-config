# Copyright (c) 2015, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module Spectrum
  module Config
    class ConfigList < SimpleDelegator
      def self.create args
        args.sort.inject({}) { |ret, val| ret[val.name] = val; ret }
      end

      def initialize args
        @delegate_sd_obj = FocusList.create args
      end
    end
  end
end

