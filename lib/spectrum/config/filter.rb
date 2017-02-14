# Copyright (c) 2015, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module Spectrum
  module Config
    class Filter

      attr_accessor :id, :method

      def initialize data
        @id     = data['id']
        @method = data['method']
      end

      def apply(data)
        send(@method.to_sym, data)
      end

      def fullname data
        if data.respond_to?(:map)
          data.map(&:fullname)
        else
          data.fullname
        end
      end
    end
  end
end
