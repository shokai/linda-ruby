# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'linda/version'

Gem::Specification.new do |spec|
  spec.name          = "linda"
  spec.version       = Linda::VERSION
  spec.authors       = ["Sho Hashimoto"]
  spec.email         = ["hashimoto@shokai.org"]
  spec.description   = %q{Tuple and TupleSpace implementation of Linda - coordinational language for parallel processing}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/shokai/linda-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/).reject{|i| i == "Gemfile.lock" }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
