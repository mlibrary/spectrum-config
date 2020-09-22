# frozen_string_literal: true
module Spectrum
  module Config
    module FacetParents
      def self.configure(root)
        file = File.join(root, 'config', 'facet_parents.yml')
        @parents_lists = YAML.load_file(file) if File.exist?(file)
      end

      def self.find(uid, value)
        return [] unless @parents_lists
        return [] unless @parents_lists.key? uid
        return [] unless @parents_lists[uid].key? value
        @parents_lists[uid][value]
      end
    end
  end
end
