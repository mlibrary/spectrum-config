# Copyright (c) 2015, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module Spectrum
  module Config
    class ActionList < ConfigList
      CONTAINS = Action
      def configure!
        __getobj__.values.each do |action|
          action.configure!
        end
      end
    end
  end
end
