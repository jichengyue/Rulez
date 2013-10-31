$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rulez/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rulez"
  s.version     = Rulez::VERSION
  s.authors     = ["MyTablers"]
  s.email       = ["development@mytable.it"]
  s.homepage    = "https://github.com/mytablers/Rulez"
  s.summary     = "Rulez is a Rails gem that makes rules logic awesome."
  s.description = "Rulez is a Rails gem that makes rules logic awesome."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.0.0"

  s.add_dependency "whittle", "~> 0.0.8"
  s.add_dependency "jquery-ui-rails", "~> 4.0"

  s.add_development_dependency 'rspec-rails', "~> 2.14.0"
  s.add_development_dependency "mysql2"
  s.add_development_dependency "yard", "~> 0.8"
  s.add_development_dependency "yard-rails", "~> 0.3"
end
