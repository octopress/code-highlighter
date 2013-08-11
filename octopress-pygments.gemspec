# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'octopress-pygments/version'

Gem::Specification.new do |gem|
  gem.name          = "octopress-pygments"
  gem.version       = Octopress::Pygments::VERSION
  gem.authors       = ["Brandon Mathis"]
  gem.email         = ["brandon@imathis.com"]
  gem.description   = %q{Octopress's core plugin for rendering nice code blocks}
  gem.summary       = %q{Octopress's core plugin for rendering nice code blocks}
  gem.homepage      = "https://github.com/octopress/octopress-pygments"
  gem.license       = "MIT"

  gem.add_dependency = 'pygments.rb >= 0.5'

  gem.files         = `git ls-files`.split($/)
  gem.require_paths = ["lib"]
end
