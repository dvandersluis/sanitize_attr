# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sanitize_attr/version'

Gem::Specification.new do |gem|
  gem.name          = "sanitize_attr"
  gem.version       = SanitizeAttr::VERSION
  gem.authors       = ["Daniel Vandersluis"]
  gem.email         = ["dvandersluis@selfmgmt.com"]
  gem.description   = %q{Automatically pass attributes through Sanitize before validation}
  gem.summary       = %q{Automatically pass attributes through Sanitize before validation.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "activerecord", ">= 3.0.0"
  gem.add_dependency "sanitize", '>= 3.0.0'

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"
end
