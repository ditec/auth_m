$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "auth_m/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "auth_m"
  s.version     = AuthM::VERSION
  s.authors     = ["me"]
  s.email       = ["me@a.com"]
  s.summary     = "Summary of AuthM."
  s.description = "Description of AuthM."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.required_ruby_version = ">= 2.4"

  s.add_dependency "devise", "~> 4.7"
  s.add_dependency "devise-security", "~> 0.14"
  s.add_dependency "role_model", "~> 0.8"
  s.add_dependency "cancancan", "~> 3.0"
  s.add_dependency "devise_invitable", "~> 2.0"
  s.add_dependency "recaptcha", "~> 5.3"

  s.add_dependency "omniauth", "~> 1.9"
  s.add_dependency "omniauth-facebook", "~> 5.0"
  s.add_dependency "omniauth-google-oauth2", "~> 0.8"
  s.add_dependency "omniauth-twitter", "~> 1.4"
  
  s.add_dependency "jquery-rails", "~> 4.3.5"

  s.add_development_dependency "rails", "~> 5.2.4.1"
  s.add_development_dependency "rails-controller-testing", "~> 1.0"
  s.add_development_dependency "mysql2", "~> 0.4.9"
  s.add_development_dependency "rspec-rails", "~> 3.6"
  s.add_development_dependency "shoulda-matchers", "~> 3.1"
  s.add_development_dependency "factory_bot_rails", "~> 4.0"
end
