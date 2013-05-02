#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs = ["lib","plugins"]
  t.test_files = FileList['test/**/*_test.rb']
end

task :ci_cleanup do
  require 'minitest/ci'
  MiniTest::Ci.clean
end

task :default => :test