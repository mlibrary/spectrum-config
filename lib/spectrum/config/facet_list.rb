# Copyright (c) 2015, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module Spectrum
  module Config
    class FacetList < MappedConfigList
      CONTAINS = Facet

      #initialize_copy wasn't being triggered.
      def clone
        newobj = super
        newobj.instance_eval do
          __getobj__.each_pair do |k,v|
            __getobj__[k] = v.clone
          end
        end
        newobj
      end

      def facet(name, data, base_url)
        __getobj__[name].spectrum(data[@mapping.invert[name]], base_url)
      end

      def spectrum(data, base_url, args = {})
        __getobj__.to_a.map {|kv| kv[1].spectrum(data[@mapping.invert[kv[0]]], base_url, args)}
      end

      def routes(source, focus, app)
        __getobj__.values.each { |facet| facet.routes(source, focus, app)}
      end

    end
  end
end
