# frozen_string_literal: true
# Copyright (c) 2015, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

require 'htmlentities'
require 'rails/html/sanitizer'

module Spectrum
  module Config
    class Filter
      attr_accessor :id, :method

      def initialize(data)
        @id     = data['id']
        @method = data['method'].to_sym
        @decoder = HTMLEntities.new
      end

      def proxy_prefix(value, request)
        case value
        when Array
          value.map { |val| proxy_prefix(val, request) }
        when String
          add_prefix(request.proxy_prefix, value)
        when Hash
          if value['uid'] == 'href'
            value.merge('value' => add_prefix(request.proxy_prefix, value['value']))
          elsif value[:uid] == 'href'
            value.merge(value: add_prefix(request.proxy_prefix, value[:value]))
          elsif value[:rows]
            value.merge(rows: value[:rows].map { |row| proxy_prefix(row, request) } )
          elsif value[:href]
            value.merge(href: add_prefix(request.proxy_prefix, value[:href]))
          elsif value['href']
            value.merge('href' => add_prefix(request.proxy_prefix, value['href']))
          elsif value[:description]
            value.merge(description: proxy_prefix(value[:description], request))
          else
            value
          end
        else
          value
        end
      end

      def add_prefix(prefix, value)
        return value unless value
        return value if value.include?('proxy.lib.umich.edu')
        return value if value.include?('libproxy.umflint.edu')
        prefix + value
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

      def apply(value, request)
        send(method, value, request)
      end

      def sanitize(value, _)
        if String === value
          Rails::Html::FullSanitizer.new.sanitize(value)
        elsif value.respond_to?(:map) && value.all? { |item| String === item }
          value.map do |item|
            sanitize(item, nil)
          end
        else
          value
        end
      end

      def truncate(value, _)
        if String === value
          if value.length > 128
            value[0, 127] + "\u2026"
          else
            value
          end
        elsif value.respond_to?(:map) && value.all? { |item| String === item }
          value.map do |item|
            truncate(item, nil)
          end
        else
          value
        end
      end

      def trim(value, _)
        if String === value
          value.sub(%r{(\S{3,})\s*[/.,:]$}, '\1')
        elsif value.respond_to?(:map) && value.all? { |item| String === item }
          value.map do |item|
            trim(item, nil)
          end
        else
          value
        end
      end

      def decode(value, _)
        if String === value
          @decoder.decode(value)
        elsif value.respond_to?(:map) && value.all? { |item| String === item }
          value.map do |item|
            @decoder.decode(item)
          end
        else
          value
        end
      end

      def unless9(value, _)
        if value.respond_to?(:map)
          list = value.map { |item| unless9(item, nil) }.compact
          if list.empty?
            nil
          else
            list
          end
        elsif value.respond_to?(:length) && value.length == 9
          nil
        else
          value
        end
      end

      def uniq(value, _)
        if value.respond_to?(:uniq)
          value.uniq
        else
          value
        end
      end

      def fullname(value, _)
        if value.respond_to?(:map)
          value.map(&:fullname)
        elsif value.respond_to?(:fullname)
          value.fullname
        else
          value
        end
      end
    end
  end
end
