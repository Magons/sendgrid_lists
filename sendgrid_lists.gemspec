$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "sendgrid_lists/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "sendgrid_lists"
  spec.version     = SendgridLists::VERSION
  spec.authors     = ["Ivan Prokopenko"]
  spec.email       = ["vanyaprokopenko@gmail.com"]
  spec.homepage    = "https://github.com/Magons/sendgrid_lists"
  spec.summary     = "Sendgrid manage active and inactive lists."
  spec.description = "Sendgrid manage active and inactive lists."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  # spec.add_dependency "rails", "~> 5.1.4"

  # spec.add_development_dependency "sqlite3"

#   gem 'sendgrid'
# gem 'sendgrid-ruby' this
end
