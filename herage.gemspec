# -*- encoding: utf-8 -*-
require File.expand_path('../lib/herage/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["olistik"]
  gem.email         = ["maurizio.demagnis@gmail.com"]
  gem.description   = %q{A RubyonRails application generator tailored to a very opinionated set of requirements}
  gem.summary       = %q{Unleash the rage with Heroku and Rails}
  gem.homepage      = ""

  gem.add_dependency 'pg'
  gem.add_dependency 'heroku', '~> 2.25.0'
  gem.add_dependency 'rails', '~> 3.2.6'
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "herage"
  gem.require_paths = ["lib"]
  gem.version       = Herage::VERSION
end
