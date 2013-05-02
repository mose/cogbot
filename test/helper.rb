require 'minitest/ci'
require 'simplecov'
require 'simplecov-rcov'

SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start

if $0 == __FILE__
  TestHelpers::load_env
  puts ENV.inspect
end

MiniTest::Ci.auto_clean = false
