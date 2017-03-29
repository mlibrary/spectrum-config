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

      def <=>(other)
        if other.respond_to? :id
          @id <=> other.id
        elsif other.respond_to? :to_s
          @id <=> other.to_s
        else
          0
        end
      end

      def apply(data)
        send(@method.to_sym, data)
      end

      def uniq(data)
        if data.respond_to?(:uniq)
          data.uniq
        else
          data
        end
      end

      def fullname(data)
        if data.respond_to?(:map)
          data.map(&:fullname)
        elsif data.respond_to?(:fullname)
          data.fullname
        else
          data
        end
      end
    end
  end
end
