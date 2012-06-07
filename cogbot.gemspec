# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cogbot/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["mose"]
  gem.email         = ["mose@mose.com"]
  gem.description   = 'Irc bot based on Cinch'
  gem.summary       = 'Yet another irc bot, more a toy and a sandbox than a real product at this stage'
  gem.homepage      = "https://github.com/mose/cogbot"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = ['cogbot']
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "cogbot"
  gem.require_paths = ["lib"]
  gem.version       = Cogbot::VERSION

  gem.add_dependency 'cinch'
  gem.add_dependency 'twitter'  # twitter plugin
  gem.add_dependency 'nokogiri' # google plugin
  gem.add_dependency 'json' # stackoverflow plugin
  gem.add_dependency 'yajl-ruby' # rubygems plugin
end
