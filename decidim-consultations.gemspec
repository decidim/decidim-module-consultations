# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "decidim/consultations/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "decidim-consultations"
  s.version = Decidim::Consultations::VERSION
  s.authors = ["Juan Salvador Perez Garcia"]
  s.email = ["jsperezg@gmail.com"]
  s.homepage = "https://github.com/decidim/decidim-module-consultations"
  s.summary = "Extends Decidim adding a first level public consultation feature"
  s.description = s.summary
  s.license = "AGPL-3.0"
  s.required_ruby_version = ">= 2.4"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-admin", ">= 0.9.0.pre", "< 0.10.0"
  s.add_dependency "decidim-comments", ">= 0.9.0.pre", "< 0.10.0"
  s.add_dependency "decidim-core", ">= 0.9.0.pre", "< 0.10.0"
  s.add_dependency "rails", "~> 5.1.4"

  s.add_development_dependency "decidim-dev", ">= 0.9.0.pre", "< 0.10.0"
end
