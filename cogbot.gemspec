# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cogbot/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["mose"]
  gem.email         = ["mose@mose.com"]
  gem.description   = 'Irc bot based on Cinch'
  gem.summary       = 'Yet another irc bot, focused on helping development teams.'
  gem.homepage      = "https://github.com/mose/cogbot"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = ['cogbot']
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "cogbot"
  gem.require_paths = ["lib"]
  gem.version       = Cogbot::VERSION

  gem.add_dependency 'cinch'
  gem.add_dependency "thor"
  gem.add_dependency "eventmachine"
  gem.add_dependency "eventmachine_httpserver"
  gem.add_dependency 'nokogiri'
  gem.add_dependency "daemons"

  gem.add_dependency 'twitter'  # twitter plugin
  gem.add_dependency 'json' # stackoverflow plugin
  gem.add_dependency 'yajl-ruby' # rubygems plugin
  gem.add_dependency 'fortune_gem' # fortune plugin

  gem.add_development_dependency 'awesome_print'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'minitest-ci'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'simplecov-rcov'
  gem.add_development_dependency 'flog'
end
