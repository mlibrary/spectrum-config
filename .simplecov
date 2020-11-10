# Copyright (c) 2016, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

require 'simplecov-lcov'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::LcovFormatter,
])

SimpleCov::Formatter::LcovFormatter.config do |c|
  c.report_with_single_file = true
  c.lcov_file_name = 'lcov.info'
  c.single_report_path = 'coverage/lcov.info'
end

SimpleCov.start do
  add_filter '.bundle'
end

