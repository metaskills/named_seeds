# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "named_seeds/version"

Gem::Specification.new do |gem|
  gem.name          = "named_seeds"
  gem.version       = NamedSeeds::VERSION
  gem.authors       = ["Ken Collins"]
  gem.email         = ["ken@metaskills.net"]
  gem.description   = %q|Named database seeds and transactions are the key to fast tests!|
  gem.summary       = %q|Replace ActiveRecord::Fixtures With #{your_factory_lib}.|
  gem.homepage      = "http://github.com/metaskills/named_seeds"
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency     'rails',             '~> 3.1'
  gem.add_runtime_dependency     'database_cleaner'
  gem.add_development_dependency 'sqlite3',           '~> 1.3'
  gem.add_development_dependency 'rake',              '~> 0.9.2'
  gem.add_development_dependency 'minitest',          '~> 2.8.1'
end
