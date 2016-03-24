# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["mose"]
  gem.email         = ["mose@mose.com"]
  gem.description   = 'Irc bot based on Cinch'
  gem.summary       = 'Yet another irc bot, focused on helping development teams.'
  gem.homepage      = "https://github.com/mose/cogbot"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = ['cogbot']
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "cogbot"
  gem.require_paths = ["lib"]
  gem.version       = File.read(File.expand_path('../CHANGELOG.md', __FILE__))[/([0-9]+\.[0-9]+\.[0-9]+)/]

  gem.add_dependency 'cinch', '2.3.1'
  gem.add_dependency "thor", '~> 0.19.1'
  gem.add_dependency "eventmachine", '1.0.9.1'
  gem.add_dependency "eventmachine_httpserver", '~> 0.2.1'
  gem.add_dependency 'nokogiri', '~> 1.6.7.1'
  gem.add_dependency "daemons", '~> 1.2.3'

  gem.add_dependency 'twitter', '~> 5.15.0'  # twitter plugin
  gem.add_dependency 'json', '~> 1.8.3' # stackoverflow plugin
  gem.add_dependency 'yajl-ruby', '~> 1.2.1' # rubygems plugin
  gem.add_dependency 'fortune_gem', '~> 0.0.8' # fortune plugin

  gem.add_development_dependency 'awesome_print'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'minitest-ci'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'simplecov-rcov'
  gem.add_development_dependency 'flog'
end
