# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cogbot/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["mose"]
  gem.email         = ["mose@mose.com"]
  gem.description   = 'Irc bot based on Cinch'
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/mose/cogbot"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = ['cogbot']
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "cogbot"
  gem.require_paths = ["lib"]
  gem.version       = Cogbot::VERSION

  gem.s.add_dependency 'cinch'
  gem.s.add_dependency 'yaml'     # config parsing
  gem.s.add_dependency 'twitter'  # twitter plugin
  gem.s.add_dependency 'nokogiri' # google plugin
end
