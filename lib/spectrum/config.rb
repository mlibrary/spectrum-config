# frozen_string_literal: true
# Copyright (c) 2015, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

require 'yaml'
require 'delegate'

require 'spectrum/config/version'
require 'spectrum/config/hierarchy'
require 'spectrum/config/source'
require 'spectrum/config/row'
require 'spectrum/config/row_list'
require 'spectrum/config/column'
require 'spectrum/config/column_list'
require 'spectrum/config/layout'
require 'spectrum/config/config'
require 'spectrum/config/config_list'
require 'spectrum/config/mapped_config_list'
require 'spectrum/config/metadata'
require 'spectrum/config/focus'
require 'spectrum/config/focus_list'
require 'spectrum/config/source_list'
require 'spectrum/config/search_field'
require 'spectrum/config/search_field_list'
require 'spectrum/config/blacklight'
require 'spectrum/config/href'
require 'spectrum/config/holdings_url'
require 'spectrum/config/get_this_url'

require 'spectrum/config/csl_base'
require 'spectrum/config/csl_literal'
require 'spectrum/config/csl_array'
require 'spectrum/config/csl_null'
require 'spectrum/config/csl'

require 'spectrum/config/highly_recommended'
require 'spectrum/config/sort'
require 'spectrum/config/sort_list'

require 'spectrum/config/marc'
require 'spectrum/config/marc_matcher'

require 'spectrum/config/condition'

require 'spectrum/config/aggregator'
require 'spectrum/config/collapsing_aggregator'
require 'spectrum/config/field_aggregator'
require 'spectrum/config/labeling_aggregator'
require 'spectrum/config/online_resource_aggregator'

require 'spectrum/config/field'
require 'spectrum/config/basic_field'
require 'spectrum/config/concat_field'
require 'spectrum/config/bookplate_field'
require 'spectrum/config/marcxml_field'
require 'spectrum/config/marcjson_field'
require 'spectrum/config/parallel_merge_field'
require 'spectrum/config/concatenate_merge_field'
require 'spectrum/config/conditional_merge_field'
require 'spectrum/config/pseudo_facet_field'
require 'spectrum/config/summon_access_url_field'
require 'spectrum/config/summon_date_field'
require 'spectrum/config/summon_year_field'
require 'spectrum/config/summon_month_field'
require 'spectrum/config/summon_day_field'
require 'spectrum/config/solr_year_field'
require 'spectrum/config/solr_month_field'
require 'spectrum/config/solr_day_field'
require 'spectrum/config/formatted_catalog_published_field'
require 'spectrum/config/formatted_article_published_field'
require 'spectrum/config/formatted_page_range_field'
require 'spectrum/config/formatted_full_title_field'
require 'spectrum/config/highly_recommended_field'
require 'spectrum/config/field_list'
require 'spectrum/config/resource_access_field'
require 'spectrum/config/summon_resource_access_field'
require 'spectrum/config/more_information_field'

require 'spectrum/config/facet_parents'
require 'spectrum/config/facet'
require 'spectrum/config/facet_list'

require 'spectrum/config/field_facet'

require 'spectrum/config/filter'
require 'spectrum/config/filter_list'

require 'spectrum/config/bookplate'
require 'spectrum/config/bookplate_list'

require 'spectrum/config/credentials'
require 'spectrum/config/action'
require 'spectrum/config/action_list'

module Spectrum
  module Config
    # Your code goes here...
  end
end
