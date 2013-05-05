# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'middleman-kss/version'

Gem::Specification.new do |spec|
  spec.name          = 'middleman-kss'
  spec.version       = Middleman::KSS::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Antti-Jussi Kovalainen']
  spec.email         = ['ajk@ajk.fi']
  spec.description   = %q{KSS (Knyle Style Sheets) helpers for Middleman}
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/darep/middleman-kss'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.8.7'
  spec.add_development_dependency 'bundler', '~> 1.3'

  spec.add_runtime_dependency('middleman-core', '~> 3.0')
  spec.add_runtime_dependency('kss', '~> 0.4')
  spec.add_runtime_dependency('redcarpet', '~> 2.2.2')
end
