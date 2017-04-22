# Copyright (c) 2015, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

require 'htmlentities'

module Spectrum
  module Config
    class Filter

      attr_accessor :id, :method

      def initialize data
        @id     = data['id']
        @method = data['method']
        @decoder = HTMLEntities.new
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

      def truncate(data)
        if String === data
          if data.length > 128
            data[0, 127] + "\u2026"
          else
            data
          end
        elsif data.respond_to?(:map) && data.all? {|item| String === item}
          data.map do |item|
            truncate(item)
          end
        else
          data
        end
      end

      def trim(data)
        if String === data
          data.sub(%r{(\S{3,})\s*[/.,:]$}, '\1')
        elsif data.respond_to?(:map) && data.all? {|item| String === item}
          data.map do |item|
            trim(item)
          end
        else
          data
        end
      end

      def decode(data)
        if String === data
          @decoder.decode(data)
        elsif data.respond_to?(:map) && data.all? {|item| String === item}
          data.map do |item|
           @decoder.decode(item)
          end
        else
          data
        end
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
