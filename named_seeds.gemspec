# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "named_seeds/version"

Gem::Specification.new do |gem|
  gem.name          = "named_seeds"
  gem.version       = NamedSeeds::VERSION
  gem.authors       = ["Ken Collins"]
  gem.email         = ["ken@metaskills.net"]
  gem.summary       = %q|Replace ActiveRecord::Fixtures With #{your_factory_lib}.|
  gem.description   = %q|Make you tests fast by augmenting them with transactional fixtures powered by your favorite factory library!|
  gem.homepage      = "http://github.com/metaskills/named_seeds"
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency     'rails', '~> 4.2.0.beta2'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest'
end
