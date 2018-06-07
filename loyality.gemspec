$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "loyalty/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "loyalty"
  s.version     = Loyalty::VERSION
  s.authors     = ["Nilesh Verma"]
  s.email       = ["nileshv@techracers.com"]
  s.homepage    = "https://www.sephora.com.mx"
  s.summary     = "Summary of loyalty."
  s.description = "Description of loyalty."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.6"

  s.add_development_dependency "pg"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "byebug"

end
