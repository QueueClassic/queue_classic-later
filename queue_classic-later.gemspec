# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'queue_classic/later/version'

Gem::Specification.new do |gem|
  gem.name          = "queue_classic-later"
  gem.version       = QC::Later::VERSION
  gem.authors       = ["Dan Peterson"]
  gem.email         = ["dpiddy@gmail.com"]
  gem.description   = %q{Do things later with queue_classic}
  gem.summary       = %q{Do things later with queue_classic}
  gem.homepage      = "https://github.com/dpiddy/queue_classic-later"

  gem.files         = `git ls-files`.split($/)
  gem.require_paths = ["lib"]

  gem.add_dependency "queue_classic", "~> 3.0"
  gem.add_development_dependency "rake"
end
