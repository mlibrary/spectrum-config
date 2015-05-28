# Copyright (c) 2015, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module Spectrum
  module Config
    class BaseFocus
      attr_accessor :name, :weight, :title, :sources, :subsource,
        :route, :placeholder, :warning, :description, :viewstyles,
        :layout, :default_viewstyle, :blacklight

      def initialize args
        @title       = args['title']
        @name        = args['name']
        @route       = args['route']
        @weight      = args['weight']
        @sources     = args['sources']
        @category    = args['category'].to_sym
        @facets      = args['facets'] || false
        @subsource   = args['subsource'] || false
        @warning     = args['warning'] || nil
        @description = args['description'] || ''
        @viewstyles  = args['viewstyles'] || nil
        @layout      = args['layout'] || {}
        @blacklight  = args['blacklight'] || Spectrum::Config::Blacklight.new
        @default_viewstyle  = args['default_viewstyle'] || nil
        route['as']  ||= route['path'] + '_index'
      end

      def viewstyles?
        !!viewstyles
      end

      def path query
        if query.empty?
          "/#{route['path']}"
        else
          "/#{route['path']}?q=#{URI.encode(query)}"
        end
      end

      def has_facets?
        @facets
      end

      def add_route app
        app.match route['path'],
          to: route['to'],
          as: route['as'].to_sym,
          defaults: route['defaults']
      end

      def search_box
        {
          'route' => route['as'] + '_path',
          'placeholder' => route['placeholder']
        }
      end

      def category_match cat
        if cat == :all || cat == category
          self
        else
          nil
        end
      end

      def <=> other
        self.weight <=> other.weight
      end
    end

    class SingleFocus < BaseFocus
    end

    class MultiFocus < BaseFocus
    end

    class NullFocus < BaseFocus
    end

    class Focus < SimpleDelegator
      def self.create args
        case args['type']
        when 'single', :single
          SingleFocus.new args
        when 'multi', :multi, 'multiple', :multiple
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
        @delegate_sd_obj = Focus.create args
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
