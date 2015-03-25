# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "named_seeds/version"

Gem::Specification.new do |spec|
  spec.name          = "named_seeds"
  spec.version       = NamedSeeds.version_string
  spec.authors       = ["Ken Collins"]
  spec.email         = ["ken@metaskills.net"]
  spec.summary       = %q|Replace ActiveRecord::Fixtures With #{your_factory_lib}.|
  spec.description   = %q|Make you tests fast by augmenting them with transactional fixtures powered by your favorite factory library!|
  spec.homepage      = "http://github.com/metaskills/named_seeds"
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency     'rails', '>= 4.0'
  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-minitest'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'sqlite3'
end
