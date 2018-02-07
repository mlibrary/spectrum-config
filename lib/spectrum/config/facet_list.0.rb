# Copyright (c) 2015, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module Spectrum
  module Config
    class FacetList < MappedConfigList
      CONTAINS = Facet

      def initialize(mapping = {}, list = {}, *rest)

# mapping is a list of get query parameters mapped to solr field names.

        begin
          @reverse_map = {}
          if mapping.respond_to?(:inject) && !mapping.respond_to?(:keys)
            @mapping = mapping.inject({}) { |memo, item| memo[item['id']] = item['id'] ; memo }
            rest.unshift(list) unless list.empty?
            list = mapping.inject({}) { |memo, item| memo[item['id']] = item ; memo }
          else
            @mapping  = mapping || {}
          end

          @reverse_map = @mapping.invert

          raise "Missing mapped #{self.class::CONTAINS} id(s) #{(@mapping.values - list.keys).join(', ')}" unless (@mapping.values - list.keys).empty?

          __setobj__(
            @mapping.values.map {|id| list[id] }.compact.map do |item|
              if item.class == self.class::CONTAINS
                item
              else
                self.class::CONTAINS.new(item, *rest)
              end
            end.sort.inject({}) do |ret, val|
              ret[val.id] = val
              ret
            end
          )
        rescue
          STDERR.puts self.class
          STDERR.puts self.class::CONTAINS
          raise
        end
      end

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
