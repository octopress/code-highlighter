# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'octopress-code-highlighter/version'

Gem::Specification.new do |gem|
  gem.name          = "octopress-code-highlighter"
  gem.version       = Octopress::CodeHighlighter::VERSION
  gem.authors       = ["Brandon Mathis"]
  gem.email         = ["brandon@imathis.com"]
  gem.summary       = %q{Octopress's core plugin for rendering nice code blocks}
  gem.homepage      = "https://github.com/octopress/code-highlighter"
  gem.license       = "MIT"

  gem.add_runtime_dependency 'jekyll', '~> 3.0'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rouge', '~> 1.3'

  gem.files         = `git ls-files`.split($/).reject {|f| f =~ /^demo\// }
  gem.require_paths = ["lib"]
end
